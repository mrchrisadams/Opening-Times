Given /^I have logged in with a valid email and password$/ do
  @user = Factory.create(:user)
  visit login_url
  fill_in "email", :with => @user.email
  fill_in "password", :with => @user.password
  click_button "Login"
  assert_contain ("Successfully logged in")
end

Given /^I have created a Facility/ do
  Factory.create(:facility)
end
