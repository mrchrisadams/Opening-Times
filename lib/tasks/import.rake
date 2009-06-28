require 'facility_xml_source'

namespace :import do

  task(:xml => [:environment]) do
    Facility.delete_all if RAILS_ENV == 'development'
    f = FacilityXmlSource.new(ENV['facility'])
    puts f.inspect
    f.import
  end

end
