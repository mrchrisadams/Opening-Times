# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def comma_to_br(text)
    text.gsub(',','<br />')
  end

  def commas_to_line_breaks(text)
    text.gsub(/,\s*/,"\n") if text
  end

  def anchor_for(text)
    content_tag(:a,'',:name=>text.slugify) + text
  end

  def anchor_to(text)
    link_to text, "##{text.slugify}"
  end

  def f_link(f)
    link = link_to h(f.full_name), facility_slug_path(f.slug)
    if f.retired_at
      content_tag :del, link
    else
      link
    end
  end

  def az_links(collection, method, selected=[])
    selected = selected.to_a
    az = []
    collection.each { |a| az << a[method][0,1].upcase }
    az = az.uniq.sort
    out = "\n"
    ('A'..'Z').each do |letter|
      if selected.include?(letter)
        out += content_tag(:span, letter, :class => 'current')
      elsif az.include?(letter)        
        out += content_tag(:a, letter, :href=> "##{letter.downcase}")
      else
        out += content_tag(:span, letter, :class => "disabled")
      end
      out += "\n"
    end
    out
  end

end

