require 'set'

class HolidaySet < ActiveRecord::Base

  has_many :holiday_events
  has_many :facilties

  validates_length_of :name, :maximum => 100

  # Returns IDs of all Services that have a bank holiday at datetime
  def self.on_holiday_facility_ids(datetime)
    set = Set.new

    connection.select_rows(sanitize_sql_array(["SELECT facilities.id FROM facilities INNER JOIN holiday_sets on facilities.holiday_set_id = holiday_sets.id INNER JOIN holiday_events ON holiday_sets.id = holiday_events.holiday_set_id WHERE holiday_events.date=?",datetime.to_date])).map{|x| set << x[0].to_i}

    return set
  end


end
