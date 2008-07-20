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
    if happened_today?(datetime)
      time_ago_in_words(datetime) + ' ago'
    else
      datetime.strftime(format || DATETIME_FORMATS[:pretty_datetime])
    end
  end
  
  def happened_today?(datetime)
    datetime > 1.days.ago
  end
  
  def columns_of(collection, columns, options={}, &block)
    i = 0
    html = capture do
      columns.times do
        haml_tag :ul, options[:ul_options] do
          items = collection.slice(i, collection.length < columns ? collection.length : (collection.length.to_f/columns.to_f).round)
          if items && !items.empty?
            for item in items do
              haml_tag :li, capture_haml{ yield item }
            end
          end
        end
        i += collection.length < columns ? collection.length : (collection.length.to_f/columns.to_f).round
      end
    end
    concat html, block.binding
  end
  
  def pagination(paginator, options={})
    haml_tag :p, :class => class_merge('pagination', options[:class]) do
      unless paginator.page_count == 1
        concat link_to('Previous', { :overwrite_params => { :page => paginator.previous_page } }, { :class => 'previous' }) if paginator.previous_page
        haml_tag(:span, paginating_links(paginator, :params => params), :class => 'pages')
        concat link_to('Next', { :overwrite_params => { :page => paginator.next_page } }, { :class => 'next' }) if paginator.next_page
      end
    end
  end
  
  def paginating_links(paginator, options = {}, html_options = {})
    name = options[:name] || PaginatingFind::Helpers::DEFAULT_OPTIONS[:name]
    params = (options[:params] || PaginatingFind::Helpers::DEFAULT_OPTIONS[:params]).clone
    
    paginating_links_each(paginator, options) do |n|
      params[name] = n
      '<span class="page">' + link_to(n, params, html_options) + '</span>'
    end
  end
  
  def class_merge(klass=nil, merge=nil)
    merge.nil? ? klass : (klass.nil? ? '' : "#{klass} ") + "#{merge}"
  end
end
