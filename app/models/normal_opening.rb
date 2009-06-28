class NormalOpening < Opening

  attr_accessible :week_day, :wday

  validates_numericality_of :sequence, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 6, :message => 'must be a valid day'

  def before_validation
    self.comment.strip! if comment
  end

  def validate
    super

    errors.add(:opens_at,"must be specified") if opens_mins.blank?
    errors.add(:closes_at,"must be specified") if closes_mins.blank?
#    errors.add(:closes_at,"must be greater than opening time") unless length_mins && length_mins > 0

#    if service
#      query = "service_id=? AND sequence=? AND ((opens_mins < ? AND closes_mins > ?) OR (opens_mins < ? AND closes_mins > ?) OR (opens_mins >= ? AND closes_mins <= ?))"
#      if new_record?
#        conditions = [query, service_id, sequence, opens_mins, opens_mins, closes_mins, closes_mins, opens_mins, closes_mins]
#      else
#        conditions = ["id <> ? AND " + query, id, service_id, sequence, opens_mins, opens_mins, closes_mins, closes_mins, opens_mins, closes_mins]
#      end
#      errors.add_to_base("overlaps with existing opening") if NormalOpening.exists?(conditions)
#    end


    # for each parent opening compare whether the start overlaps or the end, or if the opening is contained within the other opening
#    warn self.inspect
#    if opens_mins && closes_mins && self.service
#      self.service.normal_openings.each do |o|
#        next if o == self || o.opens_mins.nil? || o.closes_mins.nil?
##        warn o.inspect
#        if o.sequence == sequence &&
#          ((o.opens_mins < opens_mins && opens_mins < o.closes_mins) ||
#           (o.opens_mins < closes_mins && closes_mins < o.closes_mins) ||
#           (o.opens_mins <= opens_mins && closes_mins <= o.closes_mins))
#          warn "Match"
##          errors.add_to_base("Two or more openings overlap with each other")
#          errors.add(:week_day," - overlapping openings on this day")
#          break
#        end
#      end
#    end
  end

  def wday
    sequence_to_wday(sequence) if sequence
  end

  def wday=(input)
    self.sequence = wday_to_sequence(input)
  end

  def week_day
    Time::RFC2822_DAY_NAME[wday] if wday
  end

  def week_day=(day)
    self.wday = Time::RFC2822_DAY_NAME.index(day)
  end

  def is_open_at?(time)
    wday == time.wday && super(time)
  end

  def ==(opening)
    self.equal_times?(opening) && self.sequence == opening.sequence
  end

  def to_xml(options = {})
    return if marked_for_destruction?
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:margin=>6,:target=> options[:target], :indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    attribs = Hash.new
    attribs['week-day'] = week_day
    attribs['opens']    = opens_at("%H:%M")
    attribs['closes']   = closes_at("%H:%M")
    attribs['comment']  = comment unless comment.blank?
    xml.tag!(:opening, attribs)
    return xml
  end

  def from_xml(xml)
    unless xml.is_a?(Hpricot::Elem)
      xml = Hpricot.XML(xml)
      xml = (xml/"opening")
    end
    self.week_day  = xml["week-day"]
    self.opens_at  = xml["opens"]
    self.closes_at = xml["closes"]
    self.comment   = xml["comment"]
  end

  # Returns an array of all Service.ids which are open, minus any ignores
  def self.select_open_ids(datetime, ignore_ids=[])
    ignore_sql = "facility_id NOT IN (#{ignore_ids.to_a.join(',')}) AND " unless ignore_ids.empty?
    sequence = wday_to_sequence(datetime.wday)
    n_mins = time_to_mins(datetime)
    set = Set.new
    connection.select_rows("SELECT facility_id FROM openings WHERE #{ignore_sql} type='NormalOpening' AND sequence=#{sequence} AND opens_mins<=#{n_mins} AND closes_mins>#{n_mins}").map{|x| set << x[0].to_i}
    return set
  end

end
