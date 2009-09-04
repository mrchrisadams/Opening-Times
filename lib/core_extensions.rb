class String

  def slugify
    downcase.gsub("'",'').gsub('&',' and ').gsub(/[^A-Z0-9]/i,' ').strip.squeeze(' ').gsub(/\s/,'-')
  end

  # Capitalise words correctly
  def titlecase
    special_cases = ["McCartney","and","of","Co-operative","Co-op"]
    tmp = self
    tmp = tmp.downcase
    tmp = tmp.gsub(/\b\w/){$&.upcase}
    tmp = tmp.gsub(/'\w\b/){$&.downcase}
    for word in special_cases
      tmp = tmp.gsub(/\b#{word}\b/i,word)
    end
    tmp
  end

  def lstrip_commas
    self.gsub(/^(\s*,\s*)+/m,'')
  end

  def rstrip_commas
    self.gsub(/(\s*,\s*)+$/m,'')
  end

  def strip_commas
    self.lstrip_commas.rstrip_commas
  end

  def squeeze_commas
    self.gsub(/(\s*,\s*)+/,', ')
  end

  def tidy_commas
    self.squeeze_commas.strip_commas
  end

  def is_integer?
    self =~ /\A-?\d+\Z/
  end

  #TODO I think this is built in to Ruby 1.9
  def squish 
    self.strip.gsub(/\s+/,' ')
  end

  # Capitalise words correctly
  def titlecase
    special_cases = ["McCartney"]  
    tmp = self
    tmp = tmp.downcase
    tmp = tmp.gsub(/\b\w/){$&.upcase}
    tmp = tmp.gsub(/'\w\b/){$&.downcase}
    for word in special_cases
      tmp = tmp.gsub(/#{word}/i,word)
    end
    tmp
  end

  def tidy_text
    tmp = self
    tmp = tmp.gsub('&#039;',"'") #turn html single quote in to proper single quote
    tmp = tmp.gsub(/&amp;/i,'&') #turn html single quote in to proper single quote
    tmp = tmp.gsub(/&nbsp;/i,' ') #turn non breaking space in to regular space
    tmp = tmp.gsub(/\s/,' ')     #turn line breaks, etc to space
    tmp = tmp.gsub(/St\.(\w)/,'St. \1') # ensure space after St.
    tmp = tmp.tidy_commas
    tmp = tmp.gsub(/\(\s*\)/,'') #remove empty brackets
    tmp = tmp.squish
    tmp
  end

end
