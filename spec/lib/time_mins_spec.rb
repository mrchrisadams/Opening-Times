require File.dirname(__FILE__) + '/../spec_helper'

require 'date'

describe "parse_time" do

  # Commented out for speed, only enable to check major changes
#  it "should convert any Time string back to a Time" do
#    t = DateTime.parse("0:00")
#    1439.times do |m|
#      parse_time(t.strftime("%H:%M"),false).should == t
#      parse_time(t.strftime("%I:%M%p"),false).to_time.should == t
#      t += 1.minute
#    end

#    (1..12).each do |h|
#      t = "#{h}AM"
#      parse_time(t).should == DateTime.parse(t)
#      t = "#{h}PM"
#      parse_time(t).should == DateTime.parse(t)
#    end

#    (0..23).each do |h|
#      t = "#{h}:00"
#      parse_time(t).should == DateTime.parse(t)
#    end
#  end

  it "should return nil if the string can't be convert to a Time" do
    parse_time(nil).should be_nil
    parse_time("").should be_nil
    parse_time("foo").should be_nil
    parse_time("9BM").should be_nil
    parse_time("28:71").should be_nil
  end

  it "should convert a string to a Time (more accepting that Time.parse)" do
    parse_time("9am").should == DateTime.parse("9:00")
    parse_time("9pm").should == DateTime.parse("9:00PM")
    parse_time("12am").should == DateTime.parse("12:00am")
    parse_time("12pm").should == DateTime.parse("12:00pm")
    parse_time("13PM").should == DateTime.parse("13:00")
    parse_time("21PM").should == DateTime.parse("21:00")
    parse_time("21:00").should == DateTime.parse("9:00pm")
    parse_time("24:00").should == DateTime.parse("12:00am")
    parse_time("9.00").should == DateTime.parse("9:00")
    parse_time("21.00").should == DateTime.parse("21:00")
    parse_time("0900").should == DateTime.parse("9:00")
    parse_time("2100").should == DateTime.parse("21:00")
    parse_time("900").should == DateTime.parse("9:00")
  end

  it "should use the :meridian to help with guessing" do
    parse_time("9", :meridian => "AM").should == DateTime.parse("9AM")
    parse_time("24:00", :meridian => "AM").should == DateTime.parse("0:00")
    parse_time("24:00", :meridian => "PM").should == DateTime.parse("12:00")
  end

  it "should add a minute to times of X:29 or X:59 unless told not to" do
    parse_time("21:29", :autocorrect => true).should == DateTime.parse("21:30")
    parse_time("21:59", :autocorrect => true).should == DateTime.parse("22:00")
    parse_time("21:29", :autocorrect => false).should == DateTime.parse("21:29")
    parse_time("21:59", :autocorrect => false).should == DateTime.parse("21:59")
  end

  it "should subtract a minute to times of X:01 unless told not to" do
    parse_time("7:01", :autocorrect => true).should == DateTime.parse("7:00")
    parse_time("7:01", :autocorrect => false).should == DateTime.parse("7:01")
  end

  it "should accept strange times used by the Coop" do
    parse_time("08:00:00").should == DateTime.parse("08:00")
    parse_time("22:00:00").should == DateTime.parse("22:00")
  end

  it "should understand noon as 12pm" do
    parse_time("noon").should == DateTime.parse("12:00")
  end

  it "should understand midday as 12pm" do
    parse_time("midday").should == DateTime.parse("12:00")
  end

  it "should understand miday as 12pm" do
    parse_time("miday").should == DateTime.parse("12:00") #mispelling
  end

  it "should understand mid day as 12pm" do
    parse_time("mid day").should == DateTime.parse("12:00")
  end

  it "should understand mid-day as 12pm" do
    parse_time("mid-day").should == DateTime.parse("12:00")
  end

  it "should understand midnight as 12pm" do
    parse_time("midnight").should == DateTime.parse("0:00")
  end

end


describe "time_to_mins" do

  it "should return nil if it isn't passed a Time" do
    time_to_mins(nil).should be_nil
    time_to_mins("").should be_nil
    time_to_mins("fail").should be_nil
  end

  it "should convert every minute of the day correctly" do
    t = DateTime.parse("0:00")
    1439.times do |m|
      time_to_mins(t).should == m
      t += 1.minute
    end
  end

  it "should turn a time in to minutes past midnight" do
    time_to_mins(DateTime.parse("0:00")).should == 0
    time_to_mins(DateTime.parse("23:59")).should == 24 * 60 -1
    time_to_mins(DateTime.parse("9AM")).should == 9 * 60
    time_to_mins(DateTime.parse("5PM")).should == 17 * 60
    time_to_mins(DateTime.parse("9:33")).should == 9 * 60 + 33
    time_to_mins(DateTime.parse("0:00")).should == 0
    time_to_mins(DateTime.parse("21:00")).should == 1260
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

