require File.dirname(__FILE__) + '/../spec_helper'

require 'date'

describe "parse_time" do

  # Commented out for speed, only enable to check major changes
#  it "should convert any Time string back to a Time" do
#    t = Time.parse("0:00")
#    1439.times do |m|
#      parse_time(t.strftime("%H:%M"),false).should == t
#      parse_time(t.strftime("%I:%M%p"),false).to_time.should == t
#      t += 1.minute
#    end

#    (1..12).each do |h|
#      t = "#{h}AM"
#      parse_time(t).should == Time.parse(t)
#      t = "#{h}PM"
#      parse_time(t).should == Time.parse(t)
#    end

#    (0..23).each do |h|
#      t = "#{h}:00"
#      parse_time(t).should == Time.parse(t)
#    end
#  end

  it "should return nil if the string can't be convert to a Time" do
    parse_time("").should be_nil
    parse_time("foo").should be_nil
    parse_time("9BM").should be_nil
    parse_time("28:71").should be_nil
  end

  it "should convert a string to a Time (more accepting that Time.parse)" do
    parse_time("0:01").should == Time.parse("0:01")
    parse_time("9am").should == Time.parse("9:00")
    parse_time("9pm").should == Time.parse("9:00PM")
    parse_time("13PM").should == Time.parse("13:00")
    parse_time("21PM").should == Time.parse("21:00")
    parse_time("21:00").should == Time.parse("9:00pm")
    parse_time("9.00").should == Time.parse("9:00")
    parse_time("21.00").should == Time.parse("21:00")
    parse_time("0900").should == Time.parse("9:00")
    parse_time("2100").should == Time.parse("21:00")
    parse_time("900").should == Time.parse("9:00")
  end

  it "should understand a variety of formats for 12AM" do
    midnight = Time.parse("0:00")
    parse_time("0:00", :meridian => "AM").should == midnight
    parse_time("12", :meridian => "AM").should == midnight
    parse_time("12am", :meridian => "AM").should == midnight
    parse_time("12 AM", :meridian => "AM").should == midnight
    parse_time("12am", :meridian => "AM").should == midnight
    parse_time("24:00", :meridian => "AM").should == midnight
  end

  it "should understand a variety of formats for 12PM" do
    midday = Time.parse("12:00pm")
    parse_time("12pm", :meridian => "PM").should == midday
    parse_time("12 PM", :meridian => "PM").should == midday
    parse_time("12:00", :meridian => "PM").should == midday
    parse_time("12.00", :meridian => "PM").should == midday
  end

  it "should use the :meridian to help with guessing" do
    parse_time("9", :meridian => "AM").should == Time.parse("9AM")
    parse_time("0", :meridian => "AM").should == Time.parse("0:00")
    parse_time("12", :meridian => "AM").should == Time.parse("0:00")
    parse_time("24:00", :meridian => "AM").should == Time.parse("0:00")
    parse_time("24:00", :meridian => "PM").should == Time.parse("12:00")
  end

  it "should accept strange times used by the Coop" do
    parse_time("08:00:00").should == Time.parse("08:00")
    parse_time("22:00:00").should == Time.parse("22:00")
  end

  it "should understand noon as 12pm" do
    parse_time("noon").should == Time.parse("12:00")
  end

  it "should understand midday as 12pm" do
    parse_time("midday").should == Time.parse("12:00")
  end

  it "should understand miday as 12pm" do
    parse_time("miday").should == Time.parse("12:00") #mispelling
  end

  it "should understand mid day as 12pm" do
    parse_time("mid day").should == Time.parse("12:00")
  end

  it "should understand mid-day as 12pm" do
    parse_time("mid-day").should == Time.parse("12:00")
  end

  it "should understand midnight as 12pm" do
    parse_time("midnight").should == Time.parse("0:00")
  end

end


describe "correct_off_by_one" do
  it "should subtract a minute to times of X:01" do
    [["0:01", "0:00"], ["9:01","9:00"], ["12:01","12:00"]].each do |wrong, right|
      wrong = Time.parse(wrong)
      right = Time.parse(right)
      correct_off_by_one_min(wrong).should be_same_time_as(right)
    end
  end

  it "should add a minute to times of X:29" do
    [["0:29", "0:30"], ["9:29","9:30"], ["12:29","12:30"]].each do |wrong, right|
      wrong = Time.parse(wrong)
      right = Time.parse(right)
      correct_off_by_one_min(wrong).should be_same_time_as(right)
    end
  end

  it "should add a minute to times of X:59" do
    [["0:59", "1:00"], ["9:59","10:00"], ["11:59","12:00"], ["12:59","13:00"], ["23:59","0:00"]].each do |wrong, right|
      wrong = Time.parse(wrong)
      right = Time.parse(right)
      correct_off_by_one_min(wrong).should be_same_time_as(right)
    end
  end
end




describe "time_to_mins" do

  it "should return nil if it isn't passed a Time" do
    time_to_mins(nil).should be_nil
    time_to_mins("").should be_nil
    time_to_mins("fail").should be_nil
  end

  it "should convert every minute of the day correctly" do
    t = Time.parse("0:00")
    1439.times do |m|
      time_to_mins(t).should == m
      t += 1.minute
    end
  end

  it "should turn a time in to minutes past midnight" do
    time_to_mins(Time.parse("0:00")).should == 0
    time_to_mins(Time.parse("23:59")).should == 24 * 60 -1
    time_to_mins(Time.parse("9AM")).should == 9 * 60
    time_to_mins(Time.parse("5PM")).should == 17 * 60
    time_to_mins(Time.parse("9:33")).should == 9 * 60 + 33
    time_to_mins(Time.parse("0:00")).should == 0
    time_to_mins(Time.parse("21:00")).should == 1260
  end

end

describe "mins_to_time" do

  it "should turn minutes past midnight in to a pretty time" do
    mins_to_time(0).should == "12AM"
    mins_to_time(1).should == "12:01AM"
    mins_to_time(12 * 60).should == "12PM"
    mins_to_time(9 * 60).should == "9AM"
    mins_to_time(1439).should == "11:59PM"
    mins_to_time(1440).should == "12AM"
  end

  it "should turn minutes past midnight in to a strftime time" do
    mins_to_time(0,"%H:%M").should == "00:00"
    mins_to_time(1,"%H:%M").should == "00:01"
    mins_to_time(12 * 60,"%H:%M").should == "12:00"
    mins_to_time(9 * 60,"%H:%M").should == "09:00"
    mins_to_time(17 * 60,"%H:%M").should == "17:00"
  end

end

describe "sequence_to_wday" do
  it "should turn sequence to Time.wday" do
    sequence_to_wday(1).should == 2 #Mon
    sequence_to_wday(2).should == 3 #Tue
    sequence_to_wday(3).should == 4 #Wed
    sequence_to_wday(4).should == 5 #Thu
    sequence_to_wday(5).should == 6 #Fri
    sequence_to_wday(6).should == 0 #Sat
    sequence_to_wday(0).should == 1 #Sun
  end
end

describe "wday_to_sequence" do
  it "should turn Time.wday in to sequence" do
    wday_to_sequence(0).should == 6 #Mon
    wday_to_sequence(1).should == 0 #Tue
    wday_to_sequence(2).should == 1 #Wed
    wday_to_sequence(3).should == 2 #Thu
    wday_to_sequence(4).should == 3 #Fri
    wday_to_sequence(5).should == 4 #Sat
    wday_to_sequence(6).should == 5 #Sun
  end
end

