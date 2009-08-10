class HolidayEvent < ActiveRecord::Base

  belongs_to :holiday_set

  validates_presence_of :date, :holiday_set_id
  validates_length_of :comment, :maximum => 100, :allow_blank => true

  default_scope :order => 'date'

  named_scope :future, :conditions => ["date >= ?", Time.now.to_date]

end

