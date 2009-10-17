require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/opening_spec'

describe HolidayOpening do
  before(:each) do
    @opening = HolidayOpening.new(:facility_id => 1, :opens_at=>"9AM", :closes_at=>"5PM")
  end

  it_should_behave_like "an opening"

  it "should require opens_mins" do 
    @opening.should be_valid
    @opening.opens_mins = nil
    @opening.should_not be_valid  
  end
  
  it "should require closes_mins" do 
    @opening.should be_valid
    @opening.closes_mins = nil
    @opening.should_not be_valid
  end

  it "can be closed" do 
    @opening.should be_valid
    @opening.closed = true
    @opening.should be_valid
  end
  
  it "should set opens_mins and closes_mins to null when closed" do 
    @opening.should be_valid
    @opening.closed = true
    @opening.opens_mins.should be_nil
    @opening.closes_mins.should be_nil
  end
  

end

