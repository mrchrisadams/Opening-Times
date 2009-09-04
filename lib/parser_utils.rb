module ParserUtils

  def f_text(color, text)
    case color
      when :bold;            "\e[1m#{text}\e[0m"
      when :grey || :gray;   "\e[30m#{text}\e[0m"
      when :red;             "\e[31m#{text}\e[0m"
      when :green;           "\e[32m#{text}\e[0m"
      when :yellow;          "\e[33m#{text}\e[0m"
      when :blue;            "\e[34m#{text}\e[0m"
      when :purple;          "\e[35m#{text}\e[0m"
      when :cyan;            "\e[36m#{text}\e[0m"
      else text
    end
  end

  def strip_tags(text)
    text.gsub(/<\/?[^>]+>/, '');
  end

  def br_to_comma(text)
    text.gsub(/<br\s?\/?>/,', ')
  end

  def add_colon(text)
    text.gsub(/(\d?\d)\.?(\d\d)/,'\1:\2')
  end

  def extract_postcode(text)
    return unless text
    text = text.strip.sub(/\bo(\w\w)$/i,'0\1') # replace o with zero
    postcode = text[POSTCODE_REGX]
    return nil unless postcode
    postcode.gsub(/\s+/,'').insert(-4,' ').upcase 
  end

  def extract_address(text)
    return unless postcode = extract_postcode(text)
    p_code = postcode.sub(' ','\s?') # FIXME This is hack to replace the postcode and any text which follows
    address = text.sub(/#{p_code}.*/im,'')
    address = br_to_comma(address)
    address.gsub!(/<[^>]*>/,'')
    address = address.tidy_text
    address = address.titlecase
    address = address.split(', ').uniq.join(', ') # remove any duplicated parts
    [address, postcode]
  end

  def extract_phone(text)
    p_nums = text.scan(/(?:\+44)?[ 0-9\(\)\-]{10,16}/) # UK phone numbers min/max length (incluing bracket, etc.)
    p_nums.map { |x| x.gsub!(/\D/,'') }
    p_nums.reject! { |x| x.nil? || x.empty? || x.length < 10 }
    p_nums.each do |num|
      num.sub!(/^44/,'')
      num = case num
        when /^02/ # London (020), Southhampton & Portsmouth (023), Coventry (024), Northern Ireland (028), Cardiff (029)
          num.insert(3,') ').insert(9,' ')
        when /^08/, /^011/, /^01[2-6,9]1/ #
          num.insert(4,') ')
        when /^01697[3,4,7]/ # Brampton *still* has four digit numbers, go Brampton!
          num.insert(6,') ')
        else
          num.insert(5,') ')
      end
      num.insert(0,'(')
    end

    return nil if p_nums.empty?
    p_nums.size == 1 ? p_nums.first : p_nums
  end

  def extract_lat_lng(text)
    text.strip.scan(/(-?\d+\.\d+)\s*(?:\s|,|;)\s*(-?\d+\.\d+)/).first
  end

end
