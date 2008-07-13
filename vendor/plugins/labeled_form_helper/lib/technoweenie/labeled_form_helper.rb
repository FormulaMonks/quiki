module Technoweenie #:nodoc:
  module LabeledFormHelper
    [:form_for, :fields_for, :form_remote_for, :remote_form_for].each do |meth|
      src = <<-end_src
        def labeled_#{meth}(object_name, *args, &proc)
          options = args.last.is_a?(Hash) ? args.pop : {}
          options.update(:builder => LabeledFormBuilder)
          options[:html] ||= {}
          options.has_key?(:html) && options[:html].has_key?(:class) ? options[:html][:class] += ' labeled' : options[:html][:class] = 'labeled'
          #{meth}(object_name, *(args << options), &proc)
        end
      end_src
      module_eval src, __FILE__, __LINE__
    end

    # Returns a label tag that points to a specified attribute (identified by +method+) on an object assigned to a template
    # (identified by +object+).  Additional options on the input tag can be passed as a hash with +options+.  An alternate
    # text label can be passed as a 'text' key to +options+.
    # Example (call, result).
    #   label_for('post', 'category')
    #     <label for="post_category">Category</label>
    # 
    #   label_for('post', 'category', 'text' => 'This Category')
    #     <label for="post_category">This Category</label>
    def label_for(object_name, method, options = {})
      ActionView::Helpers::LabeledInstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_label_tag(options)
    end

    # Creates a label tag.
    #   label_tag('post_title', 'Title')
    #     <label for="post_title">Title</label>
    def label_tag(name, text, options = {})
      content_tag('label', text, { 'for' => name }.merge(options.stringify_keys))
    end
  end

  module LabeledInstanceTag #:nodoc:
    def to_label_tag(options = {})
      options = options.stringify_keys
      add_default_name_and_id(options)
      options.delete('name')
      label_tag options.delete('id'), (options.delete('text') || @method_name.humanize), options
    end
  end

  module FormBuilderMethods #:nodoc:
    def label_for(method, options = {})
      @template.label_for(@object_name, method, options.merge(:object => @object))
    end
  end

  class LabeledFormBuilder < ActionView::Helpers::FormBuilder #:nodoc:
    (%w(date_select) +
     ActionView::Helpers::FormHelper.instance_methods - 
     %w(label_for hidden_field check_box radio_button form_for fields_for)).each do |selector|
      src = <<-end_src
        def #{selector}(method, options = {})
          @template.content_tag('p', label_for(method, (options.delete(:label_options) || {})) + super + error_message_on(method))
        end
      end_src
      class_eval src, __FILE__, __LINE__
    end

    def hidden_field(method, options={})
      super
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      @template.content_tag('p', label_for(method, (options.delete(:label_options) || {})) + "<br />" + super)
    end
    
    def radio_button(method, tag_value, options = {})
      @template.content_tag('p', label_for(method, (options.delete(:label_options) || {})) + "<br />" + super)
    end

    def select(method, choices, options = {}, html_options = {})
      @template.content_tag('p', label_for(method, (options.delete(:label_options) || {})) + "<br />" + super)
    end

    def country_select(method, priority_countries = nil, options = {}, html_options = {})
      @template.content_tag('p', label_for(method, (options.delete(:label_options) || {})) + "<br />" + super)
    end

    def fields_for(object_name, *args, &proc)
      @template.labeled_fields_for(object_name, *args, &proc)
    end
  end
end