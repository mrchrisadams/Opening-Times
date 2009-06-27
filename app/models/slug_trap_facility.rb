class SlugTrapFacility < SlugTrap

  validates_uniqueness_of :slug

  def validate
# Removed to allow slugs to be created when a services changes and the new slug hasn't be assigned yet
#    errors.add(:redirect_slug,"must redirect to an existing service") unless Service.find_by_slug(self.redirect_slug)
  end

  def self.claim(old_slug, new_slug)
    s = SlugTrapFacility.find_or_create_by_slug(old_slug)
    s.redirect_slug = new_slug
    s.save
  end


end
