require 'set'

class StatusManager

  STATUS_OPEN   = :Open
  STATUS_CLOSED = :Closed
  STATUS_UNSURE = :Unsure

  def initialize(datetime=nil)
    if datetime.is_a?(Time)
      @holidays = HolidaySet.on_holiday_facility_ids(datetime)
      @statuses = StatusManager.select_status_all(datetime, @facilitys_holidays)
    else
      now = Time.now
      seconds_til_midnight = (24 * 60 * 60) - now.seconds_since_midnight.round

#      @holidays = Set.new
      @holidays = Rails.cache.fetch('facilitys_on_holiday', :expires_in=> seconds_til_midnight) { HolidaySet.on_holiday_facility_ids(now) }

      @statuses = Rails.cache.fetch('current_facilities_status', :expires_in=> 60-(now.sec)) { StatusManager.select_status_all(now, @facilitys_holidays) }
    end
  end

  def status(facility_id)
    return STATUS_CLOSED.to_s if @statuses.empty?
    facility_id = facility_id.id unless facility_id.is_a?(Fixnum) # So you can pass in either the object or the ID
    status = @statuses[facility_id] # returns either STATUS_OPEN or STATUS_UNSURE
    status ? status.to_s : STATUS_CLOSED.to_s
  end

  def on_holiday?(facility_id)
    return false if @holidays.empty?
    facility_id = facility_id.id unless facility_id.is_a?(Fixnum) # So you can pass in either the object or the ID
    @holidays.include?(facility_id)
  end

  private

  # Returns a Hash of ids pointing to their status
  def self.select_status_all(datetime, facilitys_holidays)
    open_special_ids = Set.new
    open_holiday_ids = Set.new
    ignore_holiday_ids = Set.new
    unsure_holiday_ids = Set.new

#    ignore_special_ids = SpecialOpening.select_ignore_ids(datetime)
#    open_special_ids = SpecialOpening.select_open_ids(datetime) unless ignore_special_ids.empty? # There are no SpecialOpenings

#    # This finds facilitys which have a bank holiday at datetime
#    unless facilitys_holidays.empty? # There are no facilitys which have an active holiday
#      # This checks which of holiday_active_ids are actually open
#      check_ids = facilitys_holidays - ignore_special_ids
#      ignore_holiday_ids = HolidayOpening.select_ignore_ids(datetime,check_ids)
#      open_holiday_ids = HolidayOpening.select_open_ids(datetime,check_ids)
#      unsure_holiday_ids =  check_ids - ignore_holiday_ids
#    end

    ignore_ids = Set.new
#    ignore_ids = ignore_special_ids | ignore_holiday_ids
    open_normal_ids = NormalOpening.select_open_ids(datetime,ignore_ids)

    open_facilities = open_special_ids + open_holiday_ids + open_normal_ids

    facility_statuses = Hash.new

    open_facilities.each do |id|
      facility_statuses[id] = STATUS_OPEN
    end

    unsure_holiday_ids.each do |id|
      facility_statuses[id] = STATUS_UNSURE
    end

    return facility_statuses
  end


  # Returns the Set of Facility ids which has at least one holiday opening and is in HolidayOpening mode, minus any ignores
  def self.select_ignore_ids(datetime, check_ids)
    set = Set.new
    return set if check_ids.empty?
    holiday_sql = "facility_id IN (#{check_ids.to_a.join(',')}) AND "
    connection.select_rows("SELECT facility_id FROM openings WHERE #{holiday_sql} type='HolidayOpening'").map{|x| set << x[0].to_i}
    return set
  end

  # Returns an Set of all open facility.ids which are in HolidayOpening mode, minus any ignores
  def self.select_open_ids(datetime, check_ids)
    set = Set.new
    return set if check_ids.empty?
    n_mins = time_to_mins(datetime)
    holiday_sql = "facility_id IN (#{check_ids.to_a.join(',')}) AND "
    connection.select_rows("SELECT facility_id FROM openings WHERE #{holiday_sql} type='HolidayOpening' AND sequence=#{HolidayOpening::SEQUENCE_OPEN} AND opens_mins<=#{n_mins} AND closes_mins>#{n_mins}").map{|x| set << x[0].to_i}
    return set
  end

  # Returns an Set of all facility.ids which are in HolidayOpening mode, but have no HolidayOpenings, minus any ignores
#  def self.select_unsure_ids(datetime, ignore_ids=Set.new)
#    facility.select_holiday_ids(datetime) - select_ignore_ids(datetime,ignore_ids)
#  end


  # Returns IDs of all Services that have a bank holiday at datetime
  def self.on_holiday_facility_ids(datetime)
    set = Set.new

    connection.select_rows(sanitize_sql_array(["SELECT facilities.id FROM facilities INNER JOIN holiday_sets on facilities.holiday_set_id = holiday_sets.id INNER JOIN holiday_events ON holiday_sets.id = holiday_events.holiday_set_id WHERE holiday_events.date=?",datetime.to_date])).map{|x| set << x[0].to_i}

    return set
  end


end

