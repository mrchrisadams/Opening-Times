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
