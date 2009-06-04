Given /^I have added several facilities to the database$/ do
  3.times do
    Factory.create(:facility)
  end
end
