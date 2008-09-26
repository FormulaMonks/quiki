# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  def notices(text, klass=nil)
    unless text.nil?
      text = [text] unless text.is_a?(Array)
      text.collect{ |t| haml_tag(:li, t, :class => klass) }.join("\n")
    end
  end
  
  def action_is?(action)
    params[:action] == action.to_sym
  end
  
  def selectable_link_to(title, url, selected=false, options={})
    stateful_link_to title, url, selected ? :selected : :active, options
  end
  
  def stateful_link_to(title, url, state=:active, options={})
    case state
    when :disabled
      haml_tag :span, title, :class => 'disabled_link'
    when :active
      link_to title, url, options
    when :selected
      haml_tag :span, title, :class => 'selected_link'
    end
  end
  
  def current_if(proposition)
    proposition ? 'current' : nil
  end
    
  def columns_of(collection, columns, options={}, &block)
    i = 0
    html = capture_haml do
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
  
  def menu_item(title, url, selected=false, options={}, &block)
    options.reverse_merge!(:li_options => {}, :link_options => {})
    options[:li_options][:class] = class_merge(options[:li_options][:class], (selected ? 'selected' : nil))
    text = block_given? ? capture(&block) : ''
    tag = capture do
      haml_tag(:li, link_to(title, url, options[:link_options]) + text, options[:li_options])
    end
    block_given? ? concat(tag, block.binding) : tag
  end
end
