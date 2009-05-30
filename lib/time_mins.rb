require 'date'

def parse_time(s, autocorrect=false)
  return nil unless s.is_a?(String)
  begin
    s.strip!
    s.sub!('.',':')
    s.upcase!

    s.insert(-3,':') if s =~ /^[012]?\d\d\d$/
    s.insert(-3,':00') if s =~ /^\d\d?(AM|PM)$/
    s = "0:00" if s == "24:00"

    d = DateTime.parse(s)

    if autocorrect
      # add or subtract a minute when close to hour or half hour (perhaps this should be in parser tools)
      d -= 1.minute if d.min == 1
      d += 1.minute if d.min == 29 || d.min == 59
    end

    return d
  rescue ArgumentError
    return nil
  end
end


#def parse_time(s, autocorrect=false)
#  return unless s.is_a?(String)
#  s.strip!
#  s.sub!('.',':')
#  s.upcase!

#  s.insert(-3,':') if s =~ /^[012]?\d\d\d$/
#  s.insert(-3,':00') if s =~ /^\d\d?(AM|PM)$/
#  s = "0:00" if s == "24:00"

##  twelve_hour       = "(((0?\d)|(1\d))(:|.)[0-5]\d(am|pm))"
##  twenty_four_hour  = "(((0?\d)|(1\d)|(2[0-3]))(:|.)[0-5]\d)"

##  return nil unless s =~ /^#{twelve_hour}|#{twenty_four_hour}$/i #
#  begin
##    puts "attempting #{s}"
#    if s[-2,2] =~ /AM|PM/
#      d = DateTime.strptime(s,"%H:%M%p")
#    else
#      d = DateTime.strptime(s,"%H:%M")
#    end
#    if autocorrect
#      d -= 1.minute if d.min == 1
#      d += 1.minute if d.min == 29 || d.min == 59
#    end
#    return d
#  rescue ArgumentError
#    nil
#  end
#end



# turns a Time in to minutes past midnight
def time_to_mins(time)
  time = parse_time(time) unless time.is_a?(Time) || time.is_a?(Date)
  return nil unless time
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
