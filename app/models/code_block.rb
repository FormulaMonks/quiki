require 'uv'

class CodeBlock
  attr_accessor :language, :code
  
  def initialize(language, code)
    self.language = language
    self.code = code
  end
  
  def highlight(theme)
    Uv.parse(code, 'xhtml', language, true, theme)
  end
end