class FacilityRevision < ActiveRecord::Base
  belongs_to :facility
  belongs_to :user

  def before_validation
    self.xml        = facility.to_xml
    self.length     = xml.length
    self.slug       = facility.slug
    self.comment    = facility.comment
    self.revision   = facility.revision
    self.user_id    = facility.user_id
    self.ip         = facility.updated_from_ip
  end

  def to_xml
    xml
  end

  # I would like to have this in create, but AR can't access facility until is has been fully saved and we are still within the transaction
#  def update_from_facility(f)
#    self.xml        = f.to_xml
#    self.length     = xml.length
#    self.slug       = f.slug
#    self.comment    = f.comment
#    self.revision   = f.revision + 1
#    self.created_by = f.updated_by
#  end

end
