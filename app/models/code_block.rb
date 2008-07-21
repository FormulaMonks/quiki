require 'uv'

# TODO: change "language" to "syntax" as it's more correct for this purpose
class CodeBlock < ActiveRecord::Base
  attr_accessible :code, :language, :theme

  Struct.new('Syntax', :syntax, :count) unless defined?(Struct::Syntax)

  belongs_to :page
  
  before_save :highlight

  named_scope :current, :include => :page, :conditions => [ 'pages.version = code_blocks.version' ]
  named_scope :popular, :joins => 'INNER JOIN (SELECT language, COUNT(language) AS cnt FROM code_blocks GROUP BY language) AS popular ON (popular.language = code_blocks.language)', :order => 'popular.cnt'

  class << self
    def highlight(code, language, theme='blackboard')
      Uv.parse(code, 'xhtml', language, true, theme)
    end
    
    def syntaxes(*args)
      args[0] ||= :all
      with_scope :find => { :select => 'code_blocks.language, COUNT(code_blocks.language) AS cnt', :order => 'cnt DESC', :group => 'code_blocks.language', :joins => 'INNER JOIN pages ON(pages.version = code_blocks.version AND pages.id = code_blocks.page_id)' } do
        syntaxes = find(*args)
        args[0] == :all ? syntaxes.collect{ |c| Struct::Syntax.new c.language, c.cnt.to_i } : Struct::Syntax.new(syntaxes.language, syntaxes.cnt.to_i)
      end
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