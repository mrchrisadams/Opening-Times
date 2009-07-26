require File.dirname(__FILE__) + '/../spec_helper'

shared_examples_for "an opening" do

  # @opening should be set in a before each to a valid example of the relevant type of opening
  it "should accept a valid opening" do
    @opening.should be_valid
  end

  it "should not accept negative opening times" do
    @opening.opens_at = "5:00PM"
    @opening.closes_at = "9:00AM"
    @opening.should_not be_valid
  end

  it "should not accept zero length opening times" do
    @opening.opens_at = "4:00PM"
    @opening.closes_at = "4:00PM"
    @opening.should_not be_valid
  end

  # opens minimum

  it "should accept opens_mins of 0" do
    @opening.opens_mins = 0
    @opening.should be_valid
  end

  it "should not accept opens_mins less than 0" do
    @opening.opens_mins = -1
    @opening.should_not be_valid
  end

  # opens maximum

  it "should accept opens_mins of 1439" do
    @opening.opens_mins = 1439
    @opening.closes_mins = 1440 # avoid opens > closes
    @opening.should be_valid
  end

  it "should not accept opens_mins greater than 1439" do
    @opening.opens_mins = 1440
    @opening.should_not be_valid
  end

  # closes minimum

  it "should accept closes_mins of 1" do
    @opening.opens_mins = 0 # avoid opens > closes
    @opening.closes_mins = 1
    @opening.should be_valid
  end

  it "should not accept closes_mins less than 1" do
    @opening.closes_mins = 0
    @opening.should_not be_valid
  end

  # closes maximum

  it "should accept closes_mins of 1440" do
    @opening.closes_mins = 1440
    @opening.should be_valid
  end

  it "should not accept closes_mins greater than 1440" do
    @opening.closes_mins = 1441
    @opening.should_not be_valid
  end

  # closes_at free text

  it "should accept closes_at of 9" do
    @opening.closes_at = "9"
    @opening.should be_valid
  end

  it "should accept closes_at of 24:00" do
    @opening.closes_at = "24:00"
    @opening.should be_valid
  end

  it "should accept closes_at of 0:00" do
    @opening.closes_at = "0:00"
    @opening.should be_valid
  end

  it "should accept closes_at of midnight" do
    @opening.closes_at = "midnight"
    @opening.should be_valid
  end

  # invalid times

  it "should not accept closes_at of blah" do
    @opening.closes_at = "blah"
    @opening.closes_at.should be_nil
  end

  it "should not accept closes_at of 2ab" do
    @opening.closes_at = "2ab"
    @opening.closes_at.should be_nil
  end

  it "should not accept closes_at of 87:61" do
    @opening.closes_at = "87:61"
    @opening.closes_at.should be_nil
  end

  # Time spans

  it "should allow an opening to span 24 hours" do
    @opening.opens_at = "0:00"
    @opening.closes_at = "0:00"
    @opening.should be_valid
  end

  it "should only allow an opening from 0:00 to 0:01" do
    @opening.opens_at = "0:00"
    @opening.closes_at = "0:01"
    @opening.should be_valid
  end

  it "should only allow an opening from 23:59 to 0:00" do
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
    @opening.closes_mins = time_to_mins(parse_time("10:01am")) # avoid autocorrect
    @opening.length.should eql("1 hour 1 min")

    @opening.opens_at = "0:00"
    @opening.closes_mins = time_to_mins(parse_time("0:01")) # avoid autocorrect
    @opening.length.should eql("1 min")

    @opening.opens_mins = time_to_mins(parse_time("0:01")) # avoid autocorrect
    @opening.closes_at = "0:00"
    @opening.length.should eql("23 hours 59 mins")

    @opening.opens_at = "0:00"
    @opening.closes_at = "0:00"
    @opening.length.should eql("24 hours")
  end

  it "should know whether another opening has the same opening times as itself" do
    o2 = @opening.clone
    @opening.equal_times?(o2).should be_true
    o2.opens_mins += 1
    @opening.equal_times?(o2).should be_false
    o2.opens_mins -= 1
    @opening.equal_times?(o2).should be_true
    o2.opens_mins -= 1
    @opening.equal_times?(o2).should be_false
  end

end


#describe Opening do
#  before(:each) do
#    @opening = Opening.new(:opens_at => "9am", :closes_at => "5pm")
#  end

#  it_should_behave_like "an opening"
#end

