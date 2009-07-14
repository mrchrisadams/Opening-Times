require 'parser_utils'

class Facility < ActiveRecord::Base
  acts_as_mappable :default_units => :miles,
                  :default_formula => :flat

  include ParserUtils

  has_many :normal_openings,  :dependent => :delete_all
  has_many :facility_revisions
  belongs_to :holiday_set
    attr_accessible :name, :location, :description, :lat, :lng, :address, :postcode, :phone, :email, :url, :normal_openings_attributes, :comment

  named_scope :retired, :conditions => { :retired_at => nil }

  accepts_nested_attributes_for :normal_openings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['opens_at'].blank? && attrs['closes_at'].blank? && attrs['comment'].blank? }

  def before_validation
    self.slug = full_name.slugify

    need_tidy = %w(name location description address phone email website)
    need_tidy.each do |x|
      self.attributes[x].strip! if attributes[x]
    end
    self.postcode.upcase! if postcode
    self.address.gsub!(/\s*,?\s*[\n\r]{2}/,", ") if address # turn line breaks in to comma separated
    self.revision += 1
  end

  validates_presence_of :name, :location, :slug, :address, :revision
  validates_presence_of :created_by, :updated_by
  validates_presence_of :comment, :if => :retired?
  validates_format_of :postcode, :with => POSTCODE_REGX
  validates_format_of :email, :with => EMAIL_REGX, :allow_blank => true
  validates_uniqueness_of :slug


  #TODO this should be more clever clogs
  unless RAILS_ENV == 'development'
    validates_numericality_of :lat, :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90
    validates_numericality_of :lng, :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180
  end

  def validate
    dupe = Facility.find_by_slug(slug)
    errors.add_to_base("A facility with this name and location already exists, please contact us to remove duplicates") if dupe && dupe != self
  end

  def after_validation
    self.postcode = extract_postcode(postcode) # Uppercase, tidy spaces etc
  end

  def self.find_by_slug(slug)
    find(:first, :conditions => ["slug=?",slug.slugify])
  end

  def retired?
    !retired_at.nil?
  end

  def retire(reason)
    unless retired?
      self.comment = reason
      self.retired_at = Time.now
      save
    end
  end

  def back_for_another_mission(reason)
    if retired?
      self.comment = reason
      self.retired_at = nil
      save
    end
  end

  # Virtual attributes

  def full_name
    "#{name} - #{location}"
  end

  def full_address
    "#{address}, #{postcode}"
  end

#  def to_param
#    slug
#  end

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
    self.lat = (s/"/latitude").text
    self.lng = (s/"/longitude").text

    (s/"normal-openings/opening").each do |opn|
      o = self.normal_openings.build
      o.from_xml(opn)
    end
    self
  end

  private


end
