class HolidaySet < ActiveRecord::Base

  has_many :holiday_events

  validates_length_of :name, :maximum => 100

end
