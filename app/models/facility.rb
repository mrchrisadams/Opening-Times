class Facility < ActiveRecord::Base

  def before_validation
    self.slug = full_name.slugify
  end

  def self.find_by_slug(slug)
    Facility.find(:first,:conditions=>["slug=?",slug.slugify])
  end

  def full_name
    "#{name} - #{location}"
  end

end
