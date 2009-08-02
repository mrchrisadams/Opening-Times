#require 'parser_utils'

class Facility < ActiveRecord::Base
  acts_as_mappable :default_units => :miles, :default_formula => :flat

  include ParserUtils

  has_many :normal_openings,  :dependent => :delete_all
  has_many :holiday_openings,  :dependent => :delete_all
  has_many :facility_revisions
  belongs_to :user
  belongs_to :holiday_set

  attr_accessible :name, :location, :description, :lat, :lng, :address, :postcode, :phone, :email, :url, :holiday_set_id, :normal_openings_attributes, :holiday_openings_attributes, :comment, :retired

  named_scope :active, :conditions => { :retired_at => nil }

  accepts_nested_attributes_for :normal_openings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['opens_at'].blank? && attrs['closes_at'].blank? && attrs['comment'].blank? }
  accepts_nested_attributes_for :holiday_openings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['closed'].blank? && attrs['opens_at'].blank? && attrs['closes_at'].blank? && attrs['comment'].blank? }

  def before_validation
    self.slug = full_name.slugify

    need_tidy = %w(name location description address phone email website)
    need_tidy.each do |x|
      self.attributes[x].strip! if attributes[x]
    end
    self.postcode.upcase! if postcode
    self.address.gsub!(/\s*,?\s*[\n\r]{1,2}/,", ") if address # turn line breaks in to comma separated address
  end

  validates_presence_of :name, :location, :slug, :address, :revision, :user_id, :updated_from_ip, :holiday_set_id
  validates_format_of :postcode, :with => POSTCODE_REGX
  validates_format_of :email, :with => EMAIL_REGX, :allow_blank => true
  validates_uniqueness_of :slug

  validates_presence_of :comment, :if => :retired?, :message => "must be provided if facility is marked for removal"

  validates_numericality_of :lat, :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90
  validates_numericality_of :lng, :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180

  def validate
    dupe = Facility.find_by_slug(slug)
    errors.add_to_base("A facility with this name and location already exists, please contact us to remove duplicates") if dupe && dupe != self
  end

  def after_validation
    self.postcode = extract_postcode(postcode) # Uppercase, tidy spaces etc
    update_summary_normal_openings
  end

  def before_create
    self.revision = 1
  end

  def before_update
    self.revision += 1
  end

  def after_create
    # because child objects can be accessed until the parent has been created
    # raise an exception here which causes a rollback
    # and catch the exception in the create action of the controller.
    # For update, it is just a normal validate
    raise "One or more normal opening times overlap" if overlapping_normal_opening_for_same_facility?
    raise "One or more bank holiday opening times overlap or you have a closed and non closed bank holiday opening" if overlapping_or_closed_holiday_opening_for_same_facility?
  end

  def validate_on_update
    # see note for after_create
    errors.add_to_base("One or more normal opening times overlap") if overlapping_normal_opening_for_same_facility?
    errors.add_to_base("One or more bank holiday opening times overlap or you have a closed and non closed bank holiday opening") if overlapping_or_closed_holiday_opening_for_same_facility?
  end

  def overlapping_normal_opening_for_same_facility?
    normal_openings.each do |normal_opening|
      normal_openings.each do |c|
        next if normal_opening.object_id == c.object_id || normal_opening.marked_for_destruction? || c.marked_for_destruction?
        if normal_opening.same_wday?(c.wday) &&
          (normal_opening.within_mins?(c.opens_mins) || normal_opening.within_mins?(c.opens_mins))
          return true
        end
      end
    end
    false
  end

  def overlapping_or_closed_holiday_opening_for_same_facility?
    holiday_openings.each do |holiday_opening|
      holiday_openings.each do |c|
        next if holiday_opening.object_id == c.object_id || holiday_opening.marked_for_destruction? || c.marked_for_destruction?
        if holiday_opening.closed? ||
           holiday_opening.within_mins?(c.opens_mins) || holiday_opening.within_mins?(c.opens_mins)
          return true
        end
      end
    end
    false
  end



  def self.find_by_slug(slug)
    find(:first, :conditions => ["slug=?",slug.slugify])
  end

  def retired?
    !retired_at.nil?
  end

  def retired=(value)
    self.retired_at = (value.to_i == 1) ? Time.now : nil
  end

  def back_for_another_mission(reason)
    if retired?
      self.comment = reason
      self.retired_at = nil
    end
  end

  # Virtual attributes

  def full_name
    "#{name} - #{location}"
  end

  def full_address
    "#{address}, #{postcode}"
  end

  def to_xml
    super({ :include => [:normal_openings] })
  end

  def group_set_summary(group_set)
    tmp = group_set.first.week_day
    tmp += (group_set.size == 1 ? ': ' : "-#{group_set.last.week_day}: ")
    tmp += group_set.first.summary.gsub(' ','')
  end

  # Creates something like Mon-Sat: 9am-5pm, Sun: 10am-4pm
  def update_summary_normal_openings
    out = []
    group_set = []
    prev = nil
    normal_openings.each do |opening|
      if group_set.empty?
        group_set << opening
      else
        if prev.opens_mins == opening.opens_mins && prev.closes_mins == opening.closes_mins #prev.equal_times?(opening)
          group_set << opening
        else
          out << group_set_summary(group_set)
          group_set = [opening]
        end
      end
      prev = opening
    end
    out << group_set_summary(group_set) unless group_set.empty?
    self.summary_normal_openings = out.join(', ')
  end

  def to_xml(options={})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.comment!("Generated by http://opening-times.co.uk")
    xml.facility do
      xml.tag!(:name, name)
      xml.tag!(:location, location)
      xml.tag!(:address, address)
      xml.tag!(:postcode, postcode)
      xml.tag!(:phone, phone) unless phone.blank?
      xml.tag!(:email, email) unless email.blank?
      xml.tag!(:url, url) unless url.blank?
      xml.tag!(:latitude, lat)
      xml.tag!(:longitude, lng)

#      xml.tag!(:bank_holiday_set, holiday_set.name)

      xml.tag!(:created_at, created_at)
      xml.tag!(:updated_at, updated_at)

      normal_openings.to_xml(:builder=>xml,:skip_instruct=>true) unless normal_openings.empty?
#      holiday_openings.to_xml(:builder=>xml,:skip_instruct=>true) unless holiday_openings.empty?
#      special_openings.to_xml(:builder=>xml,:skip_instruct=>true) unless special_openings.empty?
    end
  end


  def from_xml(xml)
    unless new_record?
      [normal_openings].each do |o|
        o.all.each { |x| x.mark_for_destruction }
      end
    end

    doc = Hpricot.XML(xml)

    s = (doc/"facility")
    s = (doc/"service") if s.empty?

    self.name = (s/"/name").text
    self.location = (s/"/location").text
    self.description = (s/"/description").text
    self.address = (s/"/address").text
    self.postcode = (s/"/postcode").text
    self.phone = extract_phone((s/"/phone").text)

    self.url = (s/"/url").text #TODO there needs to be a url extractor
    self.lat = (s/"/latitude").text.to_f #TODO this should do a geocode if they aren't specified
    self.lng = (s/"/longitude").text.to_f

    holiday_set = HolidaySet.find_by_name((s/"holiday_set").text)
    self.holiday_set = holiday_set || HolidaySet.first

    (s/"normal-openings/opening").each do |opn|
      o = self.normal_openings.build
      o.from_xml(opn)
    end
    self
  end

  private


end

