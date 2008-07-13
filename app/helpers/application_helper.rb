# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def notices(text, klass=nil)
    unless text.nil?
      text = [text] unless text.is_a?(Array)
      text.collect{ |t| haml_tag(:li, t, :class => klass) }.join("\n")
    end
  end
  
  def current_if(proposition)
    proposition ? 'current' : nil
  end
end
