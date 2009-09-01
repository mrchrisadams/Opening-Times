class FacilityReports < Facility

  NOON_MINS = time_to_mins(Time.parse("12:00"))

  def self.find_noon_opens_mins
    find(:all, :joins => :normal_openings, :conditions => ["opens_mins = ?", NOON_MINS], :order => 'updated_at DESC')
  end

  def self.find_noon_closes_mins
    find(:all, :joins => :normal_openings, :conditions => ["closes_mins = ?", NOON_MINS], :order => 'updated_at DESC')
  end

  def self.location_lengths
    count(:id, :group => 'length(location)').sort { |a,b| a[0].to_i <=> b[0].to_i }
  end

  def self.openings_count(min = 7, max = 7)
    min,max = max,min if min > max 
    find_by_sql("SELECT facilities.id, name, location, updated_at, count(openings.id) AS openings_count FROM facilities LEFT JOIN openings ON facilities.id = facility_id GROUP BY facilities.id HAVING openings_count < #{min} or openings_count > #{max} ORDER BY updated_at DESC")
  end

  def self.openings_length(min = 600, max = 800)
    min,max = max,min if min > max 
    Opening.find(:all, :include => :facility, :conditions => ["(closes_mins-opens_mins) BETWEEN ? AND ?", min, max], :order => 'id DESC')
  end

end

