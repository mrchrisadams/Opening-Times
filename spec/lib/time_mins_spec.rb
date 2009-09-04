require File.dirname(__FILE__) + '/../spec_helper'

require 'date'

describe "parse_time" do

  it "should return nil if the string can't be convert to a Time" do
    parse_time("", "AM").should be_nil
    parse_time("foo", "AM").should be_nil
    parse_time("9BM", "AM").should be_nil
    parse_time("28:71", "AM").should be_nil
    parse_time("", "PM").should be_nil
    parse_time("foo", "PM").should be_nil
    parse_time("9BM", "PM").should be_nil
    parse_time("28:71", "PM").should be_nil
  end

  it "should accept a twenty four hour string" do
    parse_time("09.00", "AM").should == Time.parse("9:00")
    parse_time("21.00", "PM").should == Time.parse("21:00")
  end

  it "should accept a full stop as the dividor" do
    parse_time("9.00", "AM").should == Time.parse("9:00")
    parse_time("21.00", "PM").should == Time.parse("21:00")
  end

  it "should ignore the hint, when the meridian is specified in the string" do
    parse_time("9am", "PM").should == Time.parse("9:00AM")
    parse_time("9pm", "AM").should == Time.parse("9:00PM")
  end

  it "should ignore the hint, when the string begins with 0 (twenty four hour clock)" do
    parse_time("0900", "PM").should == Time.parse("9:00")
  end

  it "should allow spaces between the time and meridian within the string" do
    parse_time("9 PM", "PM").should == Time.parse("21:00")
    parse_time("9  PM", "PM").should == Time.parse("21:00")
  end

  it "should convert a string to a Time with AM hint (more accepting that Time.parse)" do
    parse_time("0:01", "AM").should == Time.parse("0:01")
    parse_time("9", "AM").should == Time.parse("9:00")
    parse_time("9:00", "AM").should == Time.parse("9:00")
  end

  it "should convert a string to a Time with PM hint (more accepting that Time.parse)" do
    parse_time("21:00", "PM").should == Time.parse("21:00")
    parse_time("2100", "PM").should == Time.parse("21:00")
    parse_time("900", "PM").should == Time.parse("21:00")
    parse_time("9", "PM").should == Time.parse("21:00")
  end

  it "should convert 1800 to a Time of 18:00" do
    parse_time("1800", "PM").should == Time.parse("18:00")
  end

  it "should understand a variety of formats for 12AM" do
    midnight = Time.parse("0:00")
    parse_time("0", "AM").should == midnight
    parse_time("0:00", "AM").should == midnight
    parse_time("12", "AM").should == midnight
    parse_time("12am", "AM").should == midnight
    parse_time("12 AM", "AM").should == midnight
    parse_time("12am", "AM").should == midnight
    parse_time("24:00", "AM").should == midnight
  end

  it "should understand a variety of formats for 12PM" do
    midday = Time.parse("12:00pm")
    parse_time("12", "PM").should == midday
    parse_time("12pm", "PM").should == midday
    parse_time("12 PM", "PM").should == midday
    parse_time("12:00", "PM").should == midday
    parse_time("12.00", "PM").should == midday
  end

  it "should use the :meridian to help with guessing" do
    parse_time("9", "AM").should == Time.parse("9AM")
    parse_time("0", "AM").should == Time.parse("0:00")
    parse_time("12", "AM").should == Time.parse("0:00")
    parse_time("24:00", "AM").should == Time.parse("0:00")
    parse_time("24:00", "PM").should == Time.parse("12:00")
  end

  it "should accept strange times used by the Coop" do
    parse_time("08:00:00", "AM").should == Time.parse("08:00")
    parse_time("22:00:00", "PM").should == Time.parse("22:00")
  end

  it "should understand noon as 12pm" do
    parse_time("noon", "AM").should == Time.parse("12:00")
    parse_time("noon", "PM").should == Time.parse("12:00")
  end

  it "should understand midday as 12pm" do
    parse_time("midday", "AM").should == Time.parse("12:00")
    parse_time("midday", "PM").should == Time.parse("12:00")
  end

  it "should understand miday as 12pm" do
    parse_time("miday", "AM").should == Time.parse("12:00") #mispelling
    parse_time("miday", "PM").should == Time.parse("12:00") #mispelling
  end

  it "should understand mid day as 12pm" do
    parse_time("mid day", "AM").should == Time.parse("12:00")
    parse_time("mid day", "PM").should == Time.parse("12:00")
  end

  it "should understand mid-day as 12pm" do
    parse_time("mid-day", "AM").should == Time.parse("12:00")
    parse_time("mid-day", "PM").should == Time.parse("12:00")
  end

  it "should understand midnight as 12pm" do
    parse_time("midnight", "AM").should == Time.parse("0:00")
    parse_time("midnight", "PM").should == Time.parse("0:00")
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

describe "mins_to_length" do

  it "should turn minutes in to a length of time" do
    mins_to_length(0).should == "0 mins"

    mins_to_length(1).should == "1 min"
    mins_to_length(2).should == "2 mins"

    mins_to_length(60).should == "1 hour"
    mins_to_length(120).should == "2 hours"

    mins_to_length(61).should == "1 hour 1 min"
    mins_to_length(62).should == "1 hour 2 mins"

    mins_to_length(121).should == "2 hours 1 min"
    mins_to_length(122).should == "2 hours 2 mins"

    mins_to_length(1439).should == "23 hours 59 mins"
    mins_to_length(1440).should == "24 hours"
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

