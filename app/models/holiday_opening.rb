require 'set'

class HolidayOpening < Opening

  SEQUENCE_OPEN = 0
  SEQUENCE_CLOSED = 1

  belongs_to :facility

  attr_accessible :closed

  def before_validation
    self.opens_mins = self.closes_mins = nil if closed?
  end

  def validate
    super
    unless closed?
      errors.add(:opens_at, "must be a valid time or opening set to closed") if opens_mins.blank?
      errors.add(:closes_at, "must be a valid time or opening set to closed") if closes_mins.blank?
    end
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
    unless self.closed = !!xml["closed"]
      self.opens_at  = xml["opens"]
      self.closes_at = xml["closes"]
    end
    self.comment   = xml["comment"]
  end


end

