Given /^I have a facility which is retired$/ do
  @facility = Factory.create(:facility, :retired => 1, :comment => "retired for test")
end
