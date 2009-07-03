Given /^I have logged in with a valid email and password$/ do
  @user = Factory.create(:user)
  visit login_url
  fill_in "email", :with => @user.email
  fill_in "password", :with => @user.password
  click_button "Login"
  assert_contain ("Successfully logged in")
end

Given /^I have created a(?: new)? Facility/ do
  Factory.create(:facility)
end

Given /^I have Facility which is on revision (\d+)$/ do |revision|
  f = Factory.create(:facility)
  revision.to_i.times do |r|
    f.name += " revision #{r}"
    f.save
  end
end

When /^I update that Facility$/ do
  f.name += " updated"
  f.save
end
