Given /^I have added a SlugTrapFacility for slug "([^\"]*)" to redirect to "([^\"]*)"$/ do |slug, redirect|
  SlugTrapFacility.claim(slug,redirect)
end
