require 'date'

#Turn a string in to a DateTime with a bit of manipulation
#:meridian => "AM" or "PM" to hint as which side of noon you want
#:autocorrect => true will turn 17:59 in to 18:00 and 9:01 in to 9:00
def parse_time(s, options={})
  return nil unless s.is_a?(String)
  begin
    s.strip!
    s.sub!('.',':')
    s.upcase!

    s = "12:00" if s =~ /NOON|MID[\-\s]?D?AY/
    s = "0:00" if s == "MIDNIGHT"

    if options[:meridian]
      s += options[:meridian] unless s =~ /A|PM$/ || s =~ /^0/
    end

    s.insert(-3,':') if s =~ /^[012]?\d\d\d$/
    s.insert(-3,':00') if s =~ /^\d\d?(AM|PM)$/
    s = "0:00" if s == "24:00"

    d = DateTime.parse(s)

    if options[:autocorrect]
      # add or subtract a minute when close to hour or half hour (perhaps this should be in parser tools)
      d -= 1.minute if d.min == 1
      d += 1.minute if d.min == 29 || d.min == 59
    end

    return d
  rescue ArgumentError
    return nil
  end
end

# turns a Time in to minutes past midnight
def time_to_mins(time)
  return nil unless time.is_a?(Time) || time.is_a?(Date)
  (time.hour * 60) + time.min
end

# turns minutes past midnight in to a Time
def mins_to_time(t,time_format = nil)
  return unless t.is_a?(Fixnum)
  if time_format
    Time.parse((t / 60 % 24).to_s + ':' + (t % 60).to_s.rjust(2,'0')).strftime(time_format)
  else
#    return 'midnight' if t == 0
#    return 'noon' if t == 720

    # Formats time without minutes unless neccssary, i.e. 9AM, 9:03AM, 5PM, 5:30PM
    out = (((t / 60) % 12) == 0 ? '12' : ((t / 60) % 12)).to_s
    out += ':' + (t % 60).to_s.rjust(2,'0') unless (t % 60) == 0
    out += (t % 1440 == 0 || (t % 1440) / 60 < 12) ? 'AM' : 'PM'
    out
  end
end

def sequence_to_wday(s)
  (s + 8) % 7 if s.is_a?(Fixnum)
end

def wday_to_sequence(w)
  (w - 8) % 7 if w.is_a?(Fixnum)
end

