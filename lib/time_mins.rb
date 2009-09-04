require 'date'

#Turn a string in to a DateTime with a bit of guess work,
# parse_time("9", "AM"), hint should be "AM" or "PM" to hint as which side of noon you want
def parse_time(s, hint=nil)
  begin
    s.gsub!(/\s/,'')
    s.sub!('.',':')
    s.upcase!

    s = "12:00PM" if s =~ /NOON|MID-?D?AY/
    s = "0:00AM" if s == "MIDNIGHT"


    s.insert(-3,':') if s =~ /^[012]?\d\d\d$/
    s.insert(-3,':00') if s =~ /^\d\d?(AM|PM)$/
    s = "0:00" if s == "24:00"

    s += hint unless hint.nil? || s =~ /A|PM$/ || s =~ /^0\d/

    d = DateTime.parse(s)
    d = Time.parse("#{d.hour}:#{d.min}")

    return d
  rescue
    return nil
  end
end

# add or subtract a minute when close to hour or half hour
def correct_off_by_one_min(time)
  case time.min
    when 1
      time - 1.minute
    when 29
      time + 1.minute
    when 59 # I'm sure there is a nice way to merge these
      time + 1.minute
    else
      time
  end
end

# turns a Time in to minutes past midnight
def time_to_mins(time)
  return nil unless time.is_a?(Time)
  (time.hour * 60) + time.min
end

# turns minutes past midnight in to a Time
def mins_to_time(t, time_format = nil)
  return unless t.is_a?(Fixnum)
  if time_format
    Time.parse((t / 60 % 24).to_s + ':' + (t % 60).to_s.rjust(2,'0')).strftime(time_format)
  else
    # Formats time without minutes unless neccssary, i.e. 9AM, 9:03AM, 5PM, 5:30PM
    out = (((t / 60) % 12) == 0 ? '12' : ((t / 60) % 12)).to_s
    out += ':' + (t % 60).to_s.rjust(2,'0') unless (t % 60) == 0
    out += (t % 1440 == 0 || (t % 1440)/60 < 12) ? 'AM' : 'PM'
    out
  end
end

def mins_to_length(t)
  out = ""
  out += pluralize(t/60, "hour") unless t/60 == 0
  out += " "
  out += pluralize(t%60, "min") unless t%60 == 0 && t != 0
  out.squish
end

def pluralize(n, s)
  "#{n} #{s}" + (n == 1 ? '' : 's')
end

def sequence_to_wday(s)
  (s + 8) % 7 if s.is_a?(Fixnum)
end

def wday_to_sequence(w)
  (w - 8) % 7 if w.is_a?(Fixnum)
end

