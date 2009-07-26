require 'set'

class HolidaySet < ActiveRecord::Base

  has_many :holiday_events
  has_many :facilties

  validates_length_of :name, :maximum => 100

end

