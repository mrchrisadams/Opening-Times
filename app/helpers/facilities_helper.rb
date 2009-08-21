module FacilitiesHelper

  def fmt_time(text)
    return unless text
    text.gsub!(/^12PM$/i,'<span class="timeword">midday</span>')
    text.gsub!(/^12AM$/i,'<span class="timeword">midnight</span>')
    text.gsub!(/am|pm/i,'<span class="ampm">\0</span>')
    text
  end

  def time_span_cells2(opens, closes)
    if opens == "12PM" && closes == "12PM"
      "<td colspan='3' align='center'>24 <span class='timeword'>hours</span></td>\n"
    else
      "<td>#{fmt_time(opens)}</td>\n<td>-</td>\n<td>#{fmt_time(closes)}</td>\n"
    end
  end

  def time_span_cells(opening)
    if opening.opens_mins == 0 && opening.closes_mins == Opening::MINUTES_IN_DAY
      "<td colspan='3' align='center'>24 <span class='timeword'>hours</span></td>\n"
    else
      "<td>#{fmt_time(opening.opens_at)}</td>\n<td>-</td>\n<td>#{fmt_time(opening.closes_at)}</td>\n"
    end
  end

  def midnight2midnight(o1,o2)
    o1 && o2 && o1.closes_mins == Opening::MINUTES_IN_DAY && o2.opens_mins == 0
  end

  # TODO this should be refactored
  def normal_openings_rows(normal_openings, highlight_day)
    return '<tr><td></td><td colspan="4"><p class="info">Sorry, this facility hasn\'t provided its normal opening times.</p></td></tr>' if normal_openings.empty?

    html = ''
    counter = 0
    [1,2,3,4,5,6,0].each do |day| # Each day of the week
      found_count = 0
      tmp_html = ""
      highlight = (!@status_manager.on_holiday?(@facility.id) && highlight_day == day) ? ' class="today"' : ''
      opening = normal_openings[counter]
      while opening && opening.wday == day # if the opening is for this day
        counter += 1
        found_count += 1
        if found_count == 1 # if there is more than one opening for this day
          tmp_html += "#{time_span_cells(opening)}"
        else
          tmp_html += "<tr#{highlight}>\n#{time_span_cells(opening)}"
        end
        tmp_html += "<td class='comment'>#{h(opening.comment)}</td>\n</tr>\n"
        opening = normal_openings[counter]
      end
      if found_count == 0 # No openings for this day
        tmp_html += "<td colspan='3' align='center'>Closed</td><td></td>\n</tr>\n"
      end

      html += "<tr#{highlight}>\n"
      unless found_count > 1
        html += "<td class='day' scope='row'>\n"
        html += "<abbr title='#{Date::DAYNAMES[day]}'>#{Date::ABBR_DAYNAMES[day]}</abbr>\n</td>" + tmp_html
      else
        html += "<td class='day' scope='row' rowspan='#{found_count}'><abbr title='#{Date::DAYNAMES[day]}'>#{Date::ABBR_DAYNAMES[day]}</abbr><br /><span class='info'>#{found_count} openings</span></td>" + tmp_html
      end

#      if midnight2midnight(normal_openings[counter-1], opening)
#        html += "<tr>\n<td></td><td colspan='3' style='text-align: center' class='comment'>Open past midnight</td></tr>"
#      end

    end
    return html
  end

  # Form helpers

  def remove_link_unless_new_record(fields)
    unless fields.object.new_record?
      out = ''
      out << fields.hidden_field(:_delete)
      out << link_to_function("remove", "$(this).up('.#{fields.object.class.name.underscore}').hide(); $(this).previous().value = '1'")
      out
    end
  end

  def add_normal_opening_link(name, form)
    link_to_function name do |page|
      normal_opening = render(:partial => 'form_normal_opening', :locals => { :ff => form, :normal_opening => form.object.normal_openings.build })
      page << %{
var new_normal_opening_id = "new_" + new Date().getTime();
$('normalOpenings').insert({ bottom: "#{ escape_javascript normal_opening }".replace(/new_\\d+/g, new_normal_opening_id) });
}
    end
  end

  def add_holiday_opening_link(name, form)
    link_to_function name do |page|
      holiday_opening = render(:partial => 'form_holiday_opening', :locals => { :ff => form, :holiday_opening => HolidayOpening.new })
      page << %{
var new_holiday_opening_id = "new_" + new Date().getTime();
$('holidayOpenings').insert({ bottom: "#{ escape_javascript holiday_opening }".replace(/new_\\d+/g, new_holiday_opening_id) });
}
    end
  end

  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f  

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end

  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end

end

