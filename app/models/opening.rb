class Opening < ActiveRecord::Base

  attr_accessible :facility_id, :opens_at, :closes_at, :comment

  MINUTES_IN_DAY = 1440 # 60 * 24
  DAYNAMES = %w(Mon Tue Wed Thu Fri Sat Sun)

  default_scope :order => 'starts_on,sequence,opens_mins'

  def validate
    errors.add(:opens_at,'must be a valid time between 0:00 and 23:59') unless opens_mins.nil? || (0..MINUTES_IN_DAY-1).include?(opens_mins)
    errors.add(:closes_at,'must be a valid time between 0:01 and 0:00') unless closes_mins.nil? || (1..MINUTES_IN_DAY).include?(closes_mins)

    errors.add(:closes_at,"time must be after opening time") if opens_mins && closes_mins && opens_mins >= closes_mins
  end

  def length_mins
    closes_mins - opens_mins if opens_mins && closes_mins
  end

  def length
    return unless t = length_mins
    out = ""
    out += (t / 60).to_s + (t / 60 == 1 ? ' hour ' : ' hours ') unless (t / 60) == 0
    out +=  (t % 60).to_s + (t % 60 == 1 ? ' min' : ' mins') unless (t % 60) == 0
    out.strip
  end

  def summary
    return '24hr' if opens_mins == 0 and closes_mins == MINUTES_IN_DAY
    "#{opens_at} - #{closes_at}"
  end

  def opens_at(strftime = nil)
    mins_to_time(opens_mins, strftime)
  end

  def opens_at=(time)
    #TODO this should be improved, really it needs a nicer time parsing method
    time += "AM" if time.is_a?(String) unless time.length > 2 || time =~ /a|pm/i
    self.opens_mins = time_to_mins(time)
  end

  def closes_at(strftime = nil)
    mins_to_time(closes_mins, strftime)
  end

  def closes_at=(time)
    #TODO this should be improved, really it needs a nicer time parsing method
    time += "PM" if time.is_a?(String) unless time =~ /^0|(a|pm)/i
    n_mins = time_to_mins(time)
    self.closes_mins = n_mins == 0 ? MINUTES_IN_DAY : n_mins
  end

  def is_open_at?(time)
    n_mins = time_to_mins(time)
    opens_mins <= n_mins and (closes_mins > n_mins or closes_mins == 0)
  end

end
