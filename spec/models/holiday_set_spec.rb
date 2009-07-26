require File.dirname(__FILE__) + '/../spec_helper'

describe HolidaySet do
  before(:each) do
    @holiday_set = Factory.create(:holiday_set)
  end

  it "should be valid" do
    @holiday_set.should be_valid
  end

end

