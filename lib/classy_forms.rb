module CitrusByte
  class ClassyForms
    class << self
      def classify(klass, options={})
        options.has_key?(:class) ? options[:class] << " #{klass}" : options[:class] = klass
        options
      end
    end
  end
end

module ActionView::Helpers
  module FormHelper
    def text_field_with_class(object_name, method, options = {})
      CitrusByte::ClassyForms.classify 'textfield', options
      text_field_without_class object_name, method, options
    end
    alias_method_chain :text_field, :class    

    def password_field_with_class(object_name, method, options = {})
      CitrusByte::ClassyForms.classify 'password', options
      password_field_without_class object_name, method, options
    end
    alias_method_chain :password_field, :class
  end
  
  module FormTagHelper
    def image_submit_tag_with_class(source, options = {})
      CitrusByte::ClassyForms.classify 'image_submit', options
      image_submit_tag_without_class source, options
    end
    alias_method_chain :image_submit_tag, :class
    
    def button_tag(value = "Button", options = {})
      options.stringify_keys!      
      tag :input, { "type" => "button", "name" => "button", "value" => value }.update(options.stringify_keys)
    end
  end
  
  class FormBuilder
    def submit_with_class(value = "Save changes", options = {})
      CitrusByte::ClassyForms.classify 'submit', options
      submit_without_class value, options
    end
    alias_method_chain :submit, :class

    def button(value = "Button", options={})
      CitrusByte::ClassyForms.classify 'button', options
      @template.button_tag(value, options.reverse_merge(:id => "#{object_name}_button"))
    end
  end
end