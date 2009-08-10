require File.dirname(__FILE__) + '/../spec_helper'

OPEN    = StatusManager::OPEN.to_s
CLOSED  = StatusManager::CLOSED.to_s
UNSURE  = StatusManager::UNSURE.to_s

describe "A StatusManager" do

  before(:each) do
    @holiday_all_uk = Time.parse("2009-01-01") # Thursday 1 Jan 2009, is a bank holiday across the UK
    @holiday_scotland = Time.parse("2009-01-02") # Friday 2 Jan 2009, is a bank holiday for Scotland

    @england_wales_h_set = Factory.create(:holiday_set, :name => "England & Wales")
    @scotland_h_set = Factory.create(:holiday_set, :name => "Scotland")
    @northern_ireland_h_set = Factory.create(:holiday_set, :name => "Northern Ireland")
  end
  
  describe "get_on_holiday_facility_ids" do

    it "should an empty set when no Facilities are on holiday" do
      s1 = StatusManager.new(@holiday_all_uk)

      s1.send(:get_on_holiday_facility_ids).should be_empty
    end

    it "should return the id off any Facility that belongs to a HolidaySet which has a HolidayEvent for that date" do
      Factory.create(:holiday_event, :holiday_set => @england_wales_h_set, :date => @holiday_all_uk)

      f1 = Factory.create(:facility, :holiday_set => @england_wales_h_set)
      f2 = Factory.create(:facility, :holiday_set => @england_wales_h_set)
      f3 = Factory.create(:facility, :holiday_set => @scotland_h_set)
      f4 = Factory.create(:facility, :holiday_set => @england_wales_h_set)

      s1 = StatusManager.new(@holiday_all_uk)

      holiday_ids = Set.new
      holiday_ids << f1.id << f2.id << f4.id
      s1.send(:get_on_holiday_facility_ids).should == holiday_ids
    end

    it "should return the id off any Facility that belongs to any HolidaySet which has a HolidayEvent for that date" do
      Factory.create(:holiday_event, :holiday_set => @england_wales_h_set, :date => @holiday_all_uk)
      Factory.create(:holiday_event, :holiday_set => @scotland_h_set, :date => @holiday_all_uk)

      f1 = Factory.create(:facility, :holiday_set => @england_wales_h_set)
      f2 = Factory.create(:facility, :holiday_set => @england_wales_h_set)
      f3 = Factory.create(:facility, :holiday_set => @england_wales_h_set)
      f4 = Factory.create(:facility, :holiday_set => @northern_ireland_h_set)
      f5 = Factory.create(:facility, :holiday_set => @scotland_h_set)
      f6 = Factory.create(:facility, :holiday_set => @scotland_h_set)

      s1 = StatusManager.new(@holiday_all_uk)

      holiday_ids = Set.new
      holiday_ids << f1.id << f2.id << f3.id << f5.id << f6.id
      s1.send(:get_on_holiday_facility_ids).should == holiday_ids
    end
  end

end


describe "A StatusManager when asked the status for a Facilty" do

  context "with only NormalOpenings" do

    before(:each) do  
      @holiday_all_uk = Time.parse("2009-01-01") # Thursday 1 Jan 2009, is a bank holiday across the UK
      @england_wales_h_set = Factory.create(:holiday_set, :name => "England & Wales")
      
      Factory.create(:holiday_event, :holiday_set => @england_wales_h_set, :date => @holiday_all_uk)

      @facility = Factory.create(:facility, :holiday_set => @england_wales_h_set)
    end

    it "should be closed when there are no Openings" do
      StatusManager.new(@t).status(@facility).should == CLOSED
    end

    it "should be able to determine whether a NormalOpening is open" do
      StatusManager.new(Time.parse("2009-01-05 9:30")).status(@facility).should == CLOSED

      @facility.normal_openings.create!(:week_day=>"Mon",:opens_at => "9am", :closes_at => "5pm")

      #Thursday 2009-01-01
      StatusManager.new(Time.parse("2009-01-05 8:59")).status(@facility).should == CLOSED
      StatusManager.new(Time.parse("2009-01-05 9:00")).status(@facility).should == OPEN
      StatusManager.new(Time.parse("2009-01-05 16:59")).status(@facility).should == OPEN
      StatusManager.new(Time.parse("2009-01-05 17:00")).status(@facility).should == CLOSED

      # next day
      StatusManager.new(Time.parse("2009-01-06 9:30")).status(@facility).should == CLOSED
    end
  end

  ###################
  # HolidayOpening
  ###################

  context "when on a Bank Holiday" do

    before(:each) do
      @england_wales_h_set = Factory.create(:holiday_set, :name => "England & Wales")
      @holiday_all_uk = Time.parse("2009-01-01") # Thursday 1 Jan 2009, is a bank holiday across the UK
      @england_wales_h_set.holiday_events.create!(:date => @holiday_all_uk)

      @facility = Factory.create(:facility, :holiday_set => @england_wales_h_set)     
    end


    it "should return an Unsure status on a HolidayEvent date if no HolidayOpening has been created, regardless of any NormalOpening status" do
      StatusManager.new(Time.parse("2009-01-01 8:59")).status(@facility).should == UNSURE
      StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE
      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == UNSURE

      @facility.normal_openings.create!(:week_day=>"Thu",:opens_at => "9am", :closes_at => "5pm")

      StatusManager.new(Time.parse("2009-01-01 8:59")).status(@facility).should == UNSURE
      StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE
      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == UNSURE
    end

    it "should return the correct status when a HolidayOpening exists on a HolidayEvent date" do
      @facility.holiday_openings.create!(:opens_at => "10am", :closes_at => "4pm")

      StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == CLOSED
      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == OPEN
    end

    it "should give any HolidayOpening absolute priority over any HolidayOpening on a HolidayEvent date" do
      @facility.normal_openings.create!(:week_day=>"Thu",:opens_at => "9am", :closes_at => "5pm")

      StatusManager.new(Time.parse("2009-01-01 8:59")).status(@facility).should == UNSURE
      StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE
      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == UNSURE

      @facility.holiday_openings.create!(:opens_at => "10am", :closes_at => "4pm")

      StatusManager.new(Time.parse("2009-01-01 8:59")).status(@facility).should == CLOSED
      StatusManager.new(Time.parse("2009-01-01 9:59")).status(@facility).should == CLOSED
      StatusManager.new(Time.parse("2009-01-01 10:00")).status(@facility).should == OPEN
      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == OPEN
      StatusManager.new(Time.parse("2009-01-01 15:59")).status(@facility).should == OPEN
      StatusManager.new(Time.parse("2009-01-01 16:00")).status(@facility).should == CLOSED
    end

    it "should give precedence to HolidayOpening when determining whether it is closed" do
      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == UNSURE

      @facility.normal_openings.create!(:week_day=>"Thu",:opens_at => "9am", :closes_at => "5pm")

      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == UNSURE

      @facility.holiday_openings.create!(:closed => true)

      StatusManager.new(Time.parse("2009-01-01 10:30")).status(@facility).should == CLOSED
    end
  end

  #####################
  # SpecialOpening
  #####################

#  it "should be able to tell when a single day SpecialOpening is open or closed" do
#    @facility.save
#    @facility.special_openings.create(:opens_at => "9am", :closes_at => "5pm", :starts_on=>"2009-01-01", :ends_on=>"2009-01-01")
#    @facility.special_openings.create(:closed => true, :starts_on=>"2008-08-13", :ends_on=>"2008-08-13")

#    #Monday 2009-01-01
#    @facility.find_special_status_at(Time.parse("2009-01-01 8:59")).should be_nil
#    @facility.find_special_status_at(Time.parse("2009-01-01 9:00")).should == OPEN

#    @facility.find_special_status_at(Time.parse("2008-08-12 8:59")).should be_nil
#    @facility.find_special_status_at(Time.parse("2008-08-12 9:00")).should be_nil
#
#    @facility.find_special_status_at(Time.parse("2008-08-13 8:59")).should == CLOSED
#    @facility.find_special_status_at(Time.parse("2008-08-13 9:00")).should == CLOSED
#  end

#  it "should be able to tell when a multi day SpecialOpening is open or closed" do
#    @facility.save
#    @facility.special_openings.create(:opens_at => "9am", :closes_at => "5pm", :starts_on=>"2008-10-06", :ends_on=>"2008-10-08")
#    @facility.special_openings.create(:closed => true, :starts_on=>"2008-10-10", :ends_on=>"2008-10-13")

#    @facility.find_special_status_at(Time.parse("2008-08-12 9:00")).should be_nil
#    @facility.find_special_status_at(Time.parse("2008-10-06 8:59")).should be_nil
#    @facility.find_special_status_at(Time.parse("2008-10-06 9:00")).should == OPEN
#    @facility.find_special_status_at(Time.parse("2008-10-07 8:59")).should be_nil
#    @facility.find_special_status_at(Time.parse("2008-10-07 9:00")).should == OPEN
#    @facility.find_special_status_at(Time.parse("2008-10-08 16:59")).should == OPEN
#    @facility.find_special_status_at(Time.parse("2008-10-08 17:00")).should be_nil

#    @facility.find_special_status_at(Time.parse("2008-10-10 6:34")).should == CLOSED
#    @facility.find_special_status_at(Time.parse("2008-10-10 18:23")).should == CLOSED
#    @facility.find_special_status_at(Time.parse("2008-10-11 8:59")).should == CLOSED
#    @facility.find_special_status_at(Time.parse("2008-10-12 9:00")).should == CLOSED
#    @facility.find_special_status_at(Time.parse("2008-10-13 16:59")).should == CLOSED
#    @facility.find_special_status_at(Time.parse("2008-10-14 0:00")).should be_nil
#  end

#  it "should give SpecialOpenings priority, followed by HolidayOpenings, then NormalOpenings for Openings which aren't closed" do
#    #Monday 2009-01-01 - HolidayEvent

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE

#    @facility.normal_openings.create!(:week_day=>"Thu",:opens_at => "9am", :closes_at => "5pm")

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE
#    StatusManager.new(Time.parse("2009-01-01 14:00")).status(@facility).should == UNSURE

#    @facility.holiday_openings.create!(:opens_at=>"10am", :closes_at=>"1pm")

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 11:00")).status(@facility).should == OPEN
#    StatusManager.new(Time.parse("2009-01-01 14:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 17:00")).status(@facility).should == CLOSED

#    @facility.special_openings.create!(:opens_at => "2pm", :closes_at => "5pm", :starts_on=>"2009-01-01", :ends_on=>"2009-01-01")

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 11:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 14:00")).status(@facility).should == OPEN
#    StatusManager.new(Time.parse("2009-01-01 17:00")).status(@facility).should == CLOSED
#  end

#  it "should give SpecialOpenings priority, followed by HolidayOpenings, then NormalOpenings for Openings which are closed" do
#    #Monday 2009-01-01 - HolidayEvent

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE

#    @facility.normal_openings.create!(:week_day=>"Thu",:opens_at => "9am", :closes_at => "5pm")

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == UNSURE
#    StatusManager.new(Time.parse("2009-01-01 14:00")).status(@facility).should == UNSURE

#    @facility.holiday_openings.create!(:opens_at=>"10am", :closes_at=>"1pm")

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 11:00")).status(@facility).should == OPEN
#    StatusManager.new(Time.parse("2009-01-01 14:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 17:00")).status(@facility).should == CLOSED

#    @facility.special_openings.create!(:closed => true, :starts_on=>"2009-01-01", :ends_on=>"2009-01-01")

#    StatusManager.new(Time.parse("2009-01-01 9:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 11:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 14:00")).status(@facility).should == CLOSED
#    StatusManager.new(Time.parse("2009-01-01 17:00")).status(@facility).should == CLOSED
#  end

end

describe "A StatusManager when asked on_holiday? for a Facilty" do

  before(:each) do
    # Thursday 1 Jan 2009, is a bank holiday across the UK
    test_date = Date.parse("2009-01-01")
    holiday_set = Factory.create(:holiday_set)
    holiday_set.holiday_events.create(:date => test_date)

    @facility = Factory.create(:facility, :holiday_set => holiday_set)
  end

  it "should return false when the Facility doesn't belong to a HolidaySet with a HolidayEvent for that date" do
    StatusManager.new(Time.parse("2009-01-05")).on_holiday?(@facility.id).should be_false
  end

  it "should return true when the Facility does belong to a HolidaySet with a HolidayEvent for that date" do
    StatusManager.new(Time.parse("2009-01-01")).on_holiday?(@facility.id).should be_true
  end

end

