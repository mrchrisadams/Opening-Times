require File.dirname(__FILE__) + '/../spec_helper'

describe Facility do

  before(:each) do
    @facility = Factory.build(:facility)
    @facility.user_id = 0
  end

  describe "overlapping_normal_opening_for_same_facility?" do
    it "should return true if two or more NormalOpenings overlap" do
      @facility.normal_openings.build(:week_day => "Mon", :opens_at => "9am", :closes_at => "5pm")
      @facility.normal_openings.build(:week_day => "Mon", :opens_at => "9am", :closes_at => "5pm")
      @facility.overlapping_normal_opening_for_same_facility?.should be_true
    end

    it "should return false when NormalOpenings don't overlap" do
      @facility.normal_openings.build(:week_day => "Mon", :opens_at => "9am", :closes_at => "5pm")
      @facility.normal_openings.build(:week_day => "Tue", :opens_at => "9am", :closes_at => "5pm")
      @facility.normal_openings.build(:week_day => "Wed", :opens_at => "9am", :closes_at => "12pm")
      @facility.normal_openings.build(:week_day => "Wed", :opens_at => "1pm", :closes_at => "5pm")
      @facility.overlapping_normal_opening_for_same_facility?.should be_false
    end
  end

  describe "overlapping_or_closed_holiday_opening_for_same_facility?" do
    it "should return true if two or more HolidayOpenings overlap" do
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.overlapping_or_closed_holiday_opening_for_same_facility?.should be_true
    end

    it "should return true if there is a closed and non-closed HolidayOpening" do
      @facility.holiday_openings.build(:closed => true)
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.overlapping_or_closed_holiday_opening_for_same_facility?.should be_true
    end

    it "should return true if there are more than one closed HolidayOpening" do
      @facility.holiday_openings.build(:closed => true)
      @facility.holiday_openings.build(:closed => true)
      @facility.overlapping_or_closed_holiday_opening_for_same_facility?.should be_true
    end

    it "should return true if there are more than one closed HolidayOpening" do
      @facility.holiday_openings.build(:closed => true)
      @facility.holiday_openings.build(:closed => true)
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.overlapping_or_closed_holiday_opening_for_same_facility?.should be_true
    end

    it "should return false when HolidayOpenings don't overlap" do
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "12pm")
      @facility.holiday_openings.build(:opens_at => "1pm", :closes_at => "5pm")
      @facility.overlapping_or_closed_holiday_opening_for_same_facility?.should be_false
    end
  end

end

