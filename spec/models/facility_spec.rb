require File.dirname(__FILE__) + '/../spec_helper'

describe Facility do

  SAMPLE_XML = File.dirname(__FILE__) + '/../sample_data/waitrose-hailsham.xml'

  before(:each) do
    @facility = Factory.build(:facility)
    @facility.user_id = 0
  end

  it "should accept all valid params" do
    @facility = Facility.new
    @facility.should_not be_valid
    @facility = Factory.build(:facility)
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

  it "should produce a summary of its openings" do
    f = Factory.build(:facility)
    f.save!
    %w(Mon Tue Wed Thu Fri Sat).each do |day|
      f.normal_openings.create!(:week_day => day, :opens_at => "9am", :closes_at => "5pm")
    end
    f.normal_openings.create!(:week_day => "Sun", :opens_at => "10am", :closes_at => "4pm")
    f.update_summary_normal_openings
    f.summary_normal_openings.should == "Mon-Sat: 9AM-5PM, Sun: 10AM-4PM"
  end

  it "should be possible to create a Facility using from_xml" do
    f = Facility.new
    f.from_xml(File.open(SAMPLE_XML).read)
    f.user_id = 0
    f.updated_from_ip = "0.0.0.0"
    f.should be_valid
    f.save!
    f.normal_openings.count.should == 7
  end

end
