class Group < ActiveRecord::Base
  has_many :group_memberships
  has_many :facilities, :through => :group_memberships

  attr_protected :slug

  named_scope :active, :conditions => 'redirect_slug IS NULL'

  validates_uniqueness_of :name, :slug
  validates_presence_of :name, :slug

  def before_validation_on_create
    self.slug = name.slugify
  end

  def to_param
    slug
  end
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:margin=>6,:target=> options[:target], :indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    attribs = Hash.new
    attribs['id'] = id
    attribs['name'] = name
    attribs['slug'] = slug
    xml.tag!(:group, attribs)
    return xml
  end

  def self.find_or_create_by_name(find_name)
    if g = find_by_slug(find_name.slugify)
      g
    else
      create(:name => find_name)
    end    
  end
  
  def self.find_ordered(*args)
    options = args.extract_options!
    with_scope(:find => { :order => "name" }) do
      find(args.first,options) 
    end
  end

end

