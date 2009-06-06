require 'parser_utils'

class Facility < ActiveRecord::Base

  include ParserUtils

  has_many :normal_openings,  :dependent => :delete_all

    attr_accessible :name, :location, :description, :lat, :lng, :address, :postcode, :phone, :email, :url, :normal_openings_attributes

  accepts_nested_attributes_for :normal_openings, :allow_destroy => true, :reject_if => proc { |attrs| attrs['opens_at'].blank? && attrs['closes_at'].blank? && attrs['comment'].blank? }

  def before_validation
    self.slug = full_name.slugify

    need_tidy = %w(name location description address phone email website)
    need_tidy.each do |x|
      self.attributes[x].strip! if attributes[x]
    end
    self.postcode.upcase! if postcode
  end

  validates_presence_of :name, :location, :address #, :created_by, :updated_by
  validates_format_of :postcode, :with => POSTCODE_REGX
  validates_format_of :email, :with => EMAIL_REGX, :allow_blank => true

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
    Facility.find(:first,:conditions=>["slug=?",slug.slugify])
  end

  # Virtual attributes

  def full_name
    "#{name} - #{location}"
  end

  def full_address
    "#{address}, #{postcode}"
  end

  def to_param
    slug
  end

  def to_xml
    super({ :include => [:normal_openings] })
  end

end
