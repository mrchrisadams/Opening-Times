require 'set'

class HolidaySet < ActiveRecord::Base

  has_many :holiday_events
  has_many :facilties

  validates_length_of :name, :maximum => 100

  def self.find_by_postcode(postcode)
    case 
      when postcode =~ /^TD|DG|KA|ML|EH|KY|FK|G|PA|PH|AB|IV|KW/
        return find_by_name("Scotland")
      when postcode =~ /^BT/
        return find_by_name("Northern Ireland")
      else
        return find_by_name("England & Wales")
    end
  end


end

