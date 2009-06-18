Given /^I haven't registered$/ do
  # nothing!
end

Given /^I have created a valid user$/ do
  @user = Factory.create(:user)
end

Given /^I have logged in successfully$/ do
  UserSession.create(:email => @user.email, :password => "foobar")
end
