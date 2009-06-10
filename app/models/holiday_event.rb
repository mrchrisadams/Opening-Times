class HolidayEvent < ActiveRecord::Base

  belongs_to :holiday_set

  validates_presence_of :date
  validates_length_of :comment, :maximum => 100, :allow_blank => true

end
