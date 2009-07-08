Given /^I have logged in with a valid email and password$/ do
  @user = Factory.create(:user)
  visit login_url
  fill_in "email", :with => @user.email
  fill_in "password", :with => @user.password
  click_button "Login"
  assert_contain ("Successfully logged in")
end

Given /^I have created a(?: new)? Facility/ do
  @facility = Factory.create(:facility)
end

Given /^I have Facility which is on revision (\d+)$/ do |revision|
  @facility = Factory.create(:facility)
  revision.to_i.times do |r|
    @facility.name += " revision #{r}"
    @facility.save
  end
end

When /^I update that Facility$/ do
  @facility.name += " updated"
  @facility.save
end
