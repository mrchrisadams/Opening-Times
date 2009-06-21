module SearchHelper

  def degrees_to_compass(d)
    if d >= 0 and d < 22.5 or d >= 337.5 and d <= 360
      ["N","North"]
    elsif d >= 22.5 && d < 67.5
      ["NE","North East"]
    elsif d >= 67.5 && d < 112.5
      ["E","East"]
    elsif d >= 112.5 && d < 157.5
      ["SE","South East"]
    elsif d >= 157.5 && d < 202.5
      ["S","South"]
    elsif d >= 202.5 && d < 247.5
      ["SW","South West"]
    elsif d >= 247.5 && d < 292.5
      ["W","West"]
    elsif d >= 292.5 && d < 337.5
      ["NW","North West"]
    end
  end

  def compass(d)
    point, text = degrees_to_compass(d)
    # decided against using abbreviated form
    content_tag :span, text, :title => text + " (#{d.round}&deg;)"
  end

  def compass_long(d)
    point, text = degrees_to_compass(d)
    content_tag :span, text, :title => "#{d.round}&deg;"
  end

end
