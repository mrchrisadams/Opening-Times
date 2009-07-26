require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/opening_spec'

describe NormalOpening do
  before(:each) do
    @opening = NormalOpening.new(:facility_id => 1, :opens_at => "9am", :closes_at => "5pm", :week_day => "Mon")
  end

  it_should_behave_like "an opening"

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

  it "should not allow overlapping times on the same day" do

  end

  it "should know whether a minute is within the opening" do
    @opening.within_mins?(time_to_mins(Time.parse("9:12AM"))).should be_true
    @opening.within_mins?(time_to_mins(Time.parse("8:12AM"))).should be_false
  end

  it "should know whether another opening is on the same day" do
    @opening.same_wday?(0).should be_false
    @opening.same_wday?(1).should be_true
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

