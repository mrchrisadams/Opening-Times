require File.dirname(__FILE__) + '/../spec_helper'

describe HolidayEvent do
  before(:each) do
    @holiday_event = Factory.create(:holiday_event)
  end

  it "should be valid" do
    @holiday_event.should be_valid
  end
end
