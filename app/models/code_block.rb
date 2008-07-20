require 'uv'

class CodeBlock < ActiveRecord::Base
  attr_accessible :code, :language, :theme
  
  belongs_to :page
  
  after_save :highlight

  class << self
    def highlight(code, language, theme='blackboard')
      Uv.parse(code, 'xhtml', language, true, theme)
    end
  end
  
  def validate
    self.errors.add(:language, "'#{language}' has no installed highlighter") unless Uv.syntaxes.include?(self.language)
  end

  protected
    def highlight
      self.highlighted = CodeBlock.highlight(code, language, theme)
    end
end