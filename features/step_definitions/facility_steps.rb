Given /^I have a facility with the name "([^\"]*)" and the location "([^\"]*)"$/ do |name, location|
  @facility = Facility.find_by_slug("#{name}-#{location}")
  unless @facility
    @facility = Factory.create(:facility, :name => name, :location => location)
  end
end
