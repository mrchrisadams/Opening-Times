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

end
