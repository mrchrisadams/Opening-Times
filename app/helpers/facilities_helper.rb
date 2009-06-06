module FacilitiesHelper

  def fmt_time(text)
    return unless text
    text.gsub!(/^12PM$/i,'midday')
    text.gsub!(/^12AM$/i,'midnight')
    text.gsub!(/am|pm/i,'<span class="ampm">\0</span>')
    text
  end

  def time_span_cells(opens,closes)
    if opens == closes
      "<td colspan='3' align='center'>24 <span class='ampm'>hours</span></td>\n"
    else
      "<td>#{fmt_time(opens)}</td>\n<td>-</td>\n<td>#{fmt_time(closes)}</td>\n"
    end
  end

  def normal_openings_rows(normal_openings, highlight_day)
    return '<tr><td></td><td colspan="4"><p class="info">Sorry, this facility hasn\'t provided its normal opening times.</p></td></tr>' if normal_openings.empty?

    html = ''
    counter = 0
    [1,2,3,4,5,6,0].each do |day| # Each day of the week
      found_count = 0
      tmp_html = ""
      highlight = highlight_day == day ? ' class="today"' : ''
      opening = normal_openings[counter]
      while opening && opening.wday == day # if the opening is for this day
        counter += 1
        found_count += 1
        if found_count == 1 # if there is more than one opening for this day
          tmp_html += "#{time_span_cells(opening.opens_at,opening.closes_at)}"
        else
          tmp_html += "<tr#{highlight}>\n#{time_span_cells(opening.opens_at,opening.closes_at)}"
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
    end
    return html
  end

  def remove_link_unless_new_record(fields)
    unless fields.object.new_record?
      out = ''
      out << fields.hidden_field(:_delete)
      out << link_to_function("remove", "$(this).up('.#{fields.object.class.name.underscore}').hide(); $(this).previous().value = '1'")
      out
    end
  end

end
