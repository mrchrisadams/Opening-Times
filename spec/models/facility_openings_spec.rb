require File.dirname(__FILE__) + '/../spec_helper'

describe Facility do

  before(:each) do
    @facility = Factory.build(:facility)
    @facility.user_id = 0
  end

  describe "should not allow NormalOpenings to overlap" do
    it "should return true if two or more NormalOpenings overlap" do
      @facility.normal_openings.build(:week_day => "Mon", :opens_at => "9am", :closes_at => "5pm")
      @facility.normal_openings.build(:week_day => "Mon", :opens_at => "9am", :closes_at => "5pm")
      @facility.should_not be_valid
    end

    it "should allow non overlapping NormalOpenings" do
      @facility.normal_openings.build(:week_day => "Mon", :opens_at => "9am", :closes_at => "5pm")
      @facility.normal_openings.build(:week_day => "Tue", :opens_at => "9am", :closes_at => "5pm")
      @facility.normal_openings.build(:week_day => "Wed", :opens_at => "9am", :closes_at => "12pm")
      @facility.normal_openings.build(:week_day => "Wed", :opens_at => "1pm", :closes_at => "5pm")
      @facility.should be_valid
    end
  end

  describe "should not allow HolidayOpenings to overlap" do
    it "should return true if two or more HolidayOpenings overlap" do
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.should_not be_valid
    end

    it "should not allow a closed HolidayOpening at the same time an a non closed HolidayOpening" do
      @facility.holiday_openings.build(:closed => true)
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "5pm")
      @facility.should_not be_valid
    end

    it "should not allow more than one closed HolidayOpening" do
      @facility.holiday_openings.build(:closed => true)
      @facility.holiday_openings.build(:closed => true)
      @facility.should_not be_valid
    end

    it "should multiple HolidayOpenings that don't overlap" do
      @facility.holiday_openings.build(:opens_at => "9am", :closes_at => "12pm")
      @facility.holiday_openings.build(:opens_at => "1pm", :closes_at => "5pm")
      @facility.should be_valid
    end
  end

end

