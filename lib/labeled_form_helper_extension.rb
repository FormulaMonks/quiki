module ActionView::Helpers
  class LabeledInstanceTag < InstanceTag #:nodoc:
    def to_label_tag(options = {})
      options = options.stringify_keys
      add_default_name_and_id(options)
      options.delete('name')
      @template_object.label_tag options.delete('id'), (options.delete('text') || @method_name.humanize), options
    end
  end
end

module Technoweenie
  module LabeledFormHelper
    def label_for(object_name, method, options = {})
      ActionView::Helpers::LabeledInstanceTag.new(object_name, method, self, nil, options.delete(:object)).to_label_tag(options)
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
    
    def color_field(method, options={})
      @template.content_tag('p', 
        label_for(method, (options.delete(:label_options) || {})) + 
        hidden_field(method, options) +
        "<span class='color_field' style='background-color:#{@object.send(method)}'>&nbsp;</span>"+
        error_message_on(method)
      )
    end
  end
end