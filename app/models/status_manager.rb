require 'set'

class StatusManager

  OPENING_STATUS_OPEN   = :Open
  OPENING_STATUS_CLOSED = :Closed
  OPENING_STATUS_UNSURE = :Unsure

  def initialize(datetime=nil)
    if datetime.is_a?(Time)
      @facilitys_holidays = facility.select_holiday_ids(datetime)
      @facilitys_status = OpeningManager.select_status_all(datetime, @facilitys_holidays)
    else
      now = Time.now
      seconds_til_midnight = (24 * 60 * 60) - now.seconds_since_midnight.round

      @facilitys_holidays = Set.new
#      @facilitys_holidays = Rails.cache.fetch('current_facilitys_holidays', :expires_in=> seconds_til_midnight) { Facility.select_holiday_ids(now) }

      @facilitys_status = Rails.cache.fetch('current_facilities_status', :expires_in=> 60-(now.sec)) { StatusManager.select_status_all(now, @facilitys_holidays) }
    end
  end

  def opening_status(facility_id)
    facility_id = facility_id.id unless facility_id.is_a?(Fixnum) # So you can pass in either the object or the ID
    status = @facilitys_status[facility_id] # returns either STATUS_OPEN or STATUS_UNSURE
    status ? status.to_s : OPENING_STATUS_CLOSED.to_s
  end

  def holiday_status(facility_id)
    @facilitys_holidays.include?(facility_id)
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

    open_facilitys = open_special_ids + open_holiday_ids + open_normal_ids

    facility_statuses = Hash.new

    open_facilitys.each do |id|
      facility_statuses[id] = OPENING_STATUS_OPEN
    end

    unsure_holiday_ids.each do |id|
      facility_statuses[id] = OPENING_STATUS_UNSURE
    end

    return facility_statuses
  end

end
