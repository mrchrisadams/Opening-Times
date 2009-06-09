# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def comma_to_br(text)
    text.gsub(',','<br />')
  end

  def comma_to_new_line(text)
    text.gsub(',',"\n")
  end

  def anchor_for(text)
    content_tag(:a,text,:name=>text.slugify)
  end

  def anchor_to(text)
    link_to text, "##{text.slugify}"
  end


end
