require File.dirname(__FILE__) + '/../spec_helper'

describe NormalOpening do
  before(:each) do
    NormalOpening.delete_all
    @opening = Factory.build(:normal_opening)
  end

  it "should accept a valid opening" do
    @opening = NormalOpening.new
    @opening.valid?
    @opening.should_not be_valid
    @opening = Factory.build(:normal_opening)
    @opening.valid?
    @opening.should be_valid
  end

  it "should not accept negative opening times" do
    @opening.opens_at = "16:00"
    @opening.closes_at = "9:00AM" # AM needed to prevent auto correct
    @opening.should_not be_valid
  end

  it "should not accept zero length opening times" do
    @opening.opens_at = "16:00"
    @opening.closes_at = "16:00"
    @opening.should_not be_valid
  end

  it "should only accept valid week days" do
    for day in %w(Mon Tue Wed Thu Fri Sat Sun) do
      @opening.week_day = day
      @opening.should be_valid
    end
    @opening.week_day = "Monday"
    @opening.should_not be_valid
    @opening.week_day = "Foo"
    @opening.should_not be_valid
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
    @opening.closes_at = Time.parse("10:01am")
    @opening.length.should eql("1 hour 1 min")

    @opening.opens_at = "0:00"
    @opening.closes_at = "0:00"
    @opening.length.should eql("24 hours")
  end

  it "should know when it is open" do
    @opening.save
    # Date set to Monday
    @opening.is_open_at?(Time.parse("2008-08-11 9:12AM")).should be_true
    @opening.is_open_at?(Time.parse("2008-08-11 8:12AM")).should be_false
    # Date set to Tuesday
    @opening.is_open_at?(Time.parse("2008-08-12 9:12AM")).should be_false
  end

  it "should know whether another NormalOpening is equal to itself" do
    o2 = @opening.clone
    (@opening == o2).should be_true
    o2.opens_mins += 1
    (@opening == o2).should be_false
    o2.opens_mins -= 1
    (@opening == o2).should be_true
    o2.opens_mins -= 1
    (@opening == o2).should be_false

    o2 = @opening.clone
    o2.wday += 1
    (@opening == o2).should be_false
  end

end

# Class method tests

#describe "NormalOpening.select_open_ids" do
#  before(:each) do
#    @service = mock(Service)
#    @service.stub!(:id).and_return(:id)
#    NormalOpening.delete_all
#    @t = Time.parse("2008-12-15 09:35") # Monday
#  end

#  it "should return an empty Set when there are no HolidayOpenings" do
#    NormalOpening.select_open_ids(@t).should == Set.new
#  end

#  it "should return a Hash of all Service.ids which have a HolidayOpening on that day" do
#    NormalOpening.create!(:service_id=>1, :week_day=>"Mon", :opens_at=>"9AM", :closes_at=>"5PM")
#    NormalOpening.create!(:service_id=>2, :week_day=>"Mon", :opens_at=>"10AM", :closes_at=>"4PM")
#    NormalOpening.create!(:service_id=>3, :week_day=>"Tue", :opens_at=>"9AM", :closes_at=>"5PM")
#    NormalOpening.create!(:service_id=>4, :week_day=>"Tue", :opens_at=>"10AM", :closes_at=>"4PM")

#    NormalOpening.select_open_ids(@t).should include(1)
#    NormalOpening.select_open_ids(@t).should_not include(2,3,4,5) # 5 - Service with no holiday openings
#    @t = @t + 2.hours # Time matters for select_open
#    NormalOpening.select_open_ids(@t).should include(1,2)
#    NormalOpening.select_open_ids(@t).should_not include(3,4,5) # 5 - Service with no holiday openings

#    @t = @t + 1.day # Time matters for select_open
#    NormalOpening.select_open_ids(@t).should include(3,4)
#    NormalOpening.select_open_ids(@t).should_not include(1,2,5) # 5 - Service with no holiday openings
#  end



#end
