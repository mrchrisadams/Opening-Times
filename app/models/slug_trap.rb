class SlugTrap < ActiveRecord::Base

  attr_accessible :slug, :redirect_slug

  validates_presence_of :slug, :redirect_slug

  def before_validation
    # slugify is non reducing on a slug so can be called safely
    self.slug = slug.slugify if slug
    self.redirect_slug = redirect_slug.slugify if redirect_slug
  end

  def validate
    errors.add(:redirect_slug,"cannot point to itself") if slug == redirect_slug
    errors.add(:redirect_slug,"cannot point to an existing SlugTrap") if SlugTrap.find_by_type_and_slug(type,redirect_slug)
  end

end
