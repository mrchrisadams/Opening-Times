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
  end

  def blank?
    sequence.blank? && opens_mins.blank? && closes_mins.blank? && comment.blank?
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

  def same_wday?(check_wday)
    wday == check_wday
  end

  def ==(opening)
    self.equal_mins?(opening) && same_wday?(opening.wday)
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
    self.week_day    = xml["week-day"]
    self.opens_mins  = time_to_mins(Time.parse(xml["opens"])) # no AM/PM hints, just 24 hour 
    self.closes_mins = time_to_mins(Time.parse(xml["closes"]))
    self.comment     = xml["comment"]
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

