# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  DATETIME_FORMATS = { :pretty_date => "%b %d %Y", :pretty_datetime => "%b %d %Y, %I:%M %p" }.freeze
  
  def notices(text, klass=nil)
    unless text.nil?
      text = [text] unless text.is_a?(Array)
      text.collect{ |t| haml_tag(:li, t, :class => klass) }.join("\n")
    end
  end
  
  def current_if(proposition)
    proposition ? 'current' : nil
  end
  
  # if the given time is less than 1 day old, it uses the time in words ago
  # helper to output the time since. if it's more than 1 day old it outputs the
  # time according to the given stftime format
  def smart_datetime(datetime, format=nil)
    if datetime < 1.days.ago
      datetime.strftime(format || DATETIME_FORMATS[:pretty_datetime])
    else
      time_ago_in_words(datetime) + ' ago'
    end
  end
end
