require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/opening_spec'

describe HolidayOpening do
  before(:each) do
    @opening = HolidayOpening.new(:facility_id => 1, :opens_at=>"9AM", :closes_at=>"5PM")
  end

  it_should_behave_like "an opening"

  it "should ensure a holiday opening is either closed or has valid openings" do
    @opening.should be_valid
    @opening.opens_mins = nil
    @opening.should_not be_valid
    @opening.opens_at = "9AM"
    @opening.should be_valid
    @opening.closes_mins = nil
    @opening.should_not be_valid
    @opening.closes_at = "5PM"
    @opening.should be_valid
    @opening.closed = true
    @opening.should be_valid
    #setting an opening to closed removes opens_mins and closes_mins
    @opening.closed = false
    @opening.should_not be_valid
    @opening.opens_mins.should eql(nil)
    @opening.closes_mins.should eql(nil)
  end

end

