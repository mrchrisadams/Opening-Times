require 'set'

class StatusManager #< ActiveRecord::Base
  include ActiveRecord

  OPEN   = :Open
  CLOSED = :Closed
  UNSURE = :Unsure

  def initialize(at=nil)
    if at.is_a?(Time)
      @at = at
      @on_holiday_facility_ids = get_on_holiday_facility_ids
      @facility_statuses = get_facility_statuses
    else
      now = Time.now
      @at = now
      seconds_til_midnight = (24 * 60 * 60) - now.seconds_since_midnight.round
      @on_holiday_facility_ids = Rails.cache.fetch('on_holiday_facility_ids', :expires_in => seconds_til_midnight) { get_on_holiday_facility_ids }
      @facility_statuses = Rails.cache.fetch('facility_statuses', :expires_in => 60-(now.sec)) { get_facility_statuses }
      
#      @on_holiday_facility_ids = @on_holiday_facility_ids.to_set
    end
  end

  def status(facility_id)
    facility_id = facility_id.id if facility_id.is_a?(Facility)
    status = @facility_statuses[facility_id] # returns either OPEN or UNSURE
    status ? status.to_s : CLOSED.to_s
  end

  def on_holiday?(facility_id)
    facility_id = facility_id.id if facility_id.is_a?(Facility)
    @on_holiday_facility_ids.include?(facility_id)
  end

  private

  # Returns IDs of all Services that have a bank holiday at
  def get_on_holiday_facility_ids
    set = Set.new
    date = @at.strftime("%Y-%m-%d")
    Base.connection.select_rows("SELECT facilities.id FROM facilities INNER JOIN holiday_sets on facilities.holiday_set_id = holiday_sets.id INNER JOIN holiday_events ON holiday_sets.id = holiday_events.holiday_set_id WHERE holiday_events.date = '#{date}'").map{ |x| set << x[0].to_i }
    return set
  end


  def get_facility_statuses
    ignore_holiday_ids = get_holiday_ignore_ids(@on_holiday_facility_ids)
    open_holiday_ids = get_holiday_open_ids(@on_holiday_facility_ids)
    unsure_holiday_ids = @on_holiday_facility_ids - ignore_holiday_ids

    open_normal_ids = get_normal_open_ids(ignore_holiday_ids)

    open_facilities = open_normal_ids + open_holiday_ids

    facility_statuses = Hash.new

    open_facilities.each do |id|
      facility_statuses[id] = OPEN
    end

    unsure_holiday_ids.each do |id|
      facility_statuses[id] = UNSURE
    end

    return facility_statuses
  end


  # Returns the Set of Facility ids which has at least one holiday opening and is in HolidayOpening mode
  def get_holiday_ignore_ids(ids_to_check)
    set = Set.new
    return set if ids_to_check.empty?
    holiday_sql = "facility_id IN (#{ids_to_check.to_a.join(',')}) AND "
    Base.connection.select_rows("SELECT facility_id FROM openings WHERE #{holiday_sql} type='HolidayOpening'").map{|x| set << x[0].to_i}
    return set
  end

  # Returns an Set of all open facility.ids which are in HolidayOpening mode, minus any ignores
  def get_holiday_open_ids(ids_to_check)
    set = Set.new
    return set if ids_to_check.empty?
    n_mins = time_to_mins(@at)
    holiday_sql = "facility_id IN (#{ids_to_check.to_a.join(',')}) AND "
    Base.connection.select_rows("SELECT facility_id FROM openings WHERE #{holiday_sql} type='HolidayOpening' AND closed=false AND opens_mins<=#{n_mins} AND closes_mins>#{n_mins}").map{|x| set << x[0].to_i}
    return set
  end


  def get_normal_open_ids(ids_to_ignore)
    set = Set.new
    n_mins = time_to_mins(@at)
    sequence = wday_to_sequence(@at.wday)
    ignore_sql = ids_to_ignore.empty? ? "" : "facility_id NOT IN (#{ids_to_ignore.to_a.join(',')}) AND "
    Base.connection.select_rows("SELECT facility_id FROM openings WHERE #{ignore_sql} type='NormalOpening' AND sequence=#{sequence} AND opens_mins<=#{n_mins} AND closes_mins>#{n_mins}").map{|x| set << x[0].to_i}
    return set
  end

end

