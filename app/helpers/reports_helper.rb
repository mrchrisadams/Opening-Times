module ReportsHelper

  def options_for_time_lengths(selected)
    options_for_select(0.step(24*60, 60).map{ |x| [mins_to_length(x),x] }, selected.to_i )
  end

  def options_for_week_day(selected)
    options_for_select(Opening::DAYNAMES.map{ |x| [x, Opening::DAYNAMES.index(x)] }, selected )
  end

end

