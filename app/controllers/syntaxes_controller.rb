class SyntaxesController < ApplicationController
  def index
    @syntaxes = CodeBlock.syntaxes :order => 'language ASC'
  end
end