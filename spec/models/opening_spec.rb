require File.dirname(__FILE__) + '/../spec_helper'

describe Opening do
  before(:each) do
#    @facility = mock(Facility)
#    @facility.stub!(:id).and_return(1)
#    @opening = Opening.new(:facility_id=>1, :opens_at=>"9AM", :closes_at=>"5PM")
    @opening = Factory.build(:opening)
  end

  it "should accept a valid opening" do
    @opening.should be_valid
  end

  it "should not accept opens_at before closes_at" do
    @opening.opens_at = "16:00"
    @opening.closes_mins = time_to_mins("9:00") # To avoid auto correct adding of PM within closes_at=
    @opening.should_not be_valid
  end

  it "should not accept zero length opening times" do
    @opening.opens_at = "16:00"
    @opening.closes_at = "16:00"
    @opening.should_not be_valid
  end

  it "should only accept valid opens_mins" do
    @opening.opens_mins = 0
    @opening.closes_mins = 1
    @opening.should be_valid
    @opening.opens_mins = 480
    @opening.closes_mins = 960
    @opening.should be_valid
    @opening.opens_mins = 1439
    @opening.closes_mins = 1440
    @opening.should be_valid

    @opening.opens_mins = 1440
    @opening.should_not be_valid
    @opening.opens_mins = -32 # strings go to zero
    @opening.should_not be_valid
  end

  it "should only accept valid opens_at times" do
    @opening.opens_at = "9AM"
    @opening.should be_valid
    @opening.opens_at = "9:00"
    @opening.should be_valid
    @opening.opens_at = "16:00"
    @opening.should be_valid
    @opening.opens_at = "4PM"
    @opening.should be_valid
    @opening.opens_at = "0:00"
    @opening.should be_valid
    @opening.opens_at = "24:00"
    @opening.should be_valid

    begin
      @opening.opens_at = "24:01"
    rescue ArgumentError, NameError => boom
      boom.class.should == ArgumentError
    end

    begin
      @opening.opens_at = "blah"
    rescue ArgumentError, NameError => boom
      boom.class.should == ArgumentError
    end
  end


  it "should only accept valid closes_mins" do
    @opening.opens_mins = 0
    @opening.closes_mins = 1
    @opening.should be_valid
    @opening.closes_mins = 480
    @opening.should be_valid
    @opening.closes_mins = 1440
    @opening.should be_valid

    @opening.closes_mins = 1441
    @opening.should_not be_valid
    @opening.closes_mins = "blah"
    @opening.should_not be_valid
  end

  it "should only accept valid opens_at times" do
    @opening.opens_at = "4am"
    @opening.closes_at = "9AM"
    @opening.should be_valid
    @opening.closes_at = "9:00"
    @opening.should be_valid
    @opening.closes_at = "16:00"
    @opening.should be_valid
    @opening.closes_at = "4PM"
    @opening.should be_valid
    @opening.closes_at = "0:00"
    @opening.should be_valid
    @opening.closes_at = "24:00"
    @opening.should be_valid

    begin
      @opening.closes_at = "24:01"
    rescue ArgumentError, NameError => boom
      boom.class.should == ArgumentError
    end

    begin
      @opening.closes_at = "blah"
    rescue ArgumentError, NameError => boom
      boom.class.should == ArgumentError
    end
  end

  it "should allow an opening to span 24 hours" do
    @opening.opens_at = "0:00"
    @opening.closes_at = "0:00"
    @opening.should be_valid
  end

  it "should only allow openings with a valid length" do
    @opening.opens_at = "9AM"
    @opening.closes_at = "8AM"
    @opening.should_not be_valid

    @opening.opens_at = "9:00"
    @opening.closes_at = "8:59AM" # to prevent auto AM/PM correct
    @opening.should_not be_valid

    @opening.opens_at = "9AM"
    @opening.closes_at = "9AM"
    @opening.should_not be_valid

    @opening.opens_at = "0:00"
    @opening.closes_at = "0:01"
    @opening.should be_valid

    @opening.opens_at = "23:59"
    @opening.closes_at = "0:00"
    @opening.should be_valid
  end

  it "should know the length of the opening in words" do
    @opening.opens_at = "9am"
    @opening.closes_at = "5pm"
    @opening.length.should eql("8 hours")

    @opening.opens_at = "9am"
    @opening.closes_at = "5:30pm"
    @opening.length.should eql("8 hours 30 mins")

    @opening.opens_at = "9am"
    @opening.closes_at = "10am"
    @opening.length.should eql("1 hour")

    @opening.opens_at = "9am"
    @opening.closes_at = "10:01am"
    @opening.length.should eql("1 hour 1 min")

    @opening.opens_at = "0:00"
    @opening.closes_at = "0:01"
    @opening.length.should eql("1 min")

    @opening.opens_at = "0:01"
    @opening.closes_at = "0:00"
    @opening.length.should eql("23 hours 59 mins")

    @opening.opens_at = "0:00"
    @opening.closes_at = "0:00"
    @opening.length.should eql("24 hours")
  end

  it "should know whether a time is within the minutes of an opening" do
    @opening.opens_at = "9am"
    @opening.closes_at = "10am"
    @opening.is_open_at?("9am").should be_true
    @opening.is_open_at?("9:30am").should be_true
    @opening.is_open_at?("9:59am").should be_true
    @opening.is_open_at?("8:59am").should be_false
    @opening.is_open_at?("10am").should be_false
    @opening.is_open_at?("10:01am").should be_false
  end

end
