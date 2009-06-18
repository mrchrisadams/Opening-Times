require File.dirname(__FILE__) + '/../spec_helper'

describe HolidaySet do
  before(:each) do
    @holiday_set = Factory.create(:holiday_set)
  end

  it "should be valid" do
    @holiday_set.should be_valid
  end
end

describe "HolidaySet.on_holiday_facility_ids" do

  it "should return an empty set for a date which isn't a HolidayEvent" do
    HolidaySet.on_holiday_facility_ids(Time.now()).should == Set.new
  end

  it "should return an empty set for a date which is a HolidayEvent but doesn't have any Facilities" do
    holiday_set = Factory.create(:holiday_set)
    holiday_set.holiday_events.create(:date => "2009-01-01")
    HolidaySet.on_holiday_facility_ids(Time.now()).should == Set.new
  end

  it "should return an set of ids for the Facilities that have a HolidayEvent on that date" do
    test_date = Date.parse("2009-01-01")
    holiday_set = Factory.create(:holiday_set)
    holiday_set.holiday_events.create(:date => test_date)

    f1 = Factory.create(:facility, :holiday_set => holiday_set)
    f2 = Factory.create(:facility)
    f3 = Factory.create(:facility, :holiday_set => holiday_set)

    on_holiday_set = Set.new << f1.id << f3.id
    HolidaySet.on_holiday_facility_ids(test_date).should == on_holiday_set
  end

end
