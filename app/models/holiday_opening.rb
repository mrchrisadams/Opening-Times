require 'set'

class HolidayOpening < Opening

  belongs_to :facility

  attr_accessible :closed

  def before_validation
    unless closed?
      self.closed = false # use false not nil
      true # return true to allow validation to continue
    end
  end

  def validate
    unless closed?
      errors.add(:opens_at, "must be a valid time or opening set to closed") if opens_mins.blank?
      errors.add(:closes_at, "must be a valid time or opening set to closed") if closes_mins.blank?
    end
    super
  end

  def closed=(state)
    if state
      self.opens_mins = self.closes_mins = nil
    end
    write_attribute(:closed, state)    
  end

  def blank?
    !closed && opens_mins.blank? && closes_mins.blank? && comment.blank?
  end

  def to_xml(options = {})
    return if marked_for_destruction?
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:margin=>6,:target=> options[:target], :indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    attribs = Hash.new
    attribs['opens']    = opens_at("%H:%M") unless closed?
    attribs['closes']   = closes_at("%H:%M") unless closed?
    attribs['closed']   = true if closed?
    attribs['comment']  = comment unless comment.blank?
    xml.tag!(:opening, attribs)
    return xml
  end

  def from_xml(xml)
    unless xml.is_a?(Hpricot::Elem)
      xml = Hpricot.XML(xml)
      xml = (xml/"opening")
    end
    unless self.closed = xml["closed"] =~ /true/
      self.opens_mins  = time_to_mins(Time.parse(xml["opens"])) # no AM/PM hints, just 24 hour 
      self.closes_mins = time_to_mins(Time.parse(xml["closes"]))
    end
    self.comment   = xml["comment"]
  end


end

