# require 'facility_xml_source'

namespace :import do

  task(:xml => [:environment]) do
    if RAILS_ENV == 'development'
      Facility.delete_all
      FacilityRevision.delete_all
      SlugTrap.delete_all
      Opening.delete_all
      Group.delete_all
      GroupMembership.delete_all
    end
    f = FacilityXmlSource.new(ENV['facility'])
    f.import
  end

end
