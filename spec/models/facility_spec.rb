require File.dirname(__FILE__) + '/../spec_helper'

describe Facility do
  before(:each) do
    @facility = Factory.build(:facility)
    @facility.created_by = @facility.updated_by = "test"
  end

  it "should be valid" do
    @facility.should be_valid
  end

  it "should accept a valid postcode" do
    @facility.postcode = "SE155TL"
    @facility.should be_valid
    @facility.postcode = "tn1 2xj"
    @facility.should be_valid
  end

  it "should not accept a invalid postcode" do
    @facility.postcode = "CRAP"
    @facility.should_not be_valid
  end

  it "should format the postcode on save" do
    @facility.postcode = "se155tl"
    @facility.save!
    @facility.postcode.should == "SE15 5TL"

    @facility.postcode = "sw1A  0aA"
    @facility.save!
    @facility.postcode.should == "SW1A 0AA"
  end

  it "should automatically create a valid slug" do
    @facility.name = "59 minute cleaners"
    @facility.location = "Wapping High St"
    @facility.should be_valid
    @facility.slug.should == "59-minute-cleaners-wapping-high-st"
  end

  it "should require a valid latitude and longitude" do
    @facility.lat = @facility.lng = nil
    @facility.should_not be_valid

    @facility.lat = 51.0
    @facility.lng = 1.1
    @facility.should be_valid

    @facility.lat = 92.0
    @facility.should_not be_valid

    @facility.lat = 51.0
    @facility.lng = 181.0
    @facility.should_not be_valid
  end

end
