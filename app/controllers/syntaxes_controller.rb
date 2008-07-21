class SyntaxesController < ApplicationController
  def index
    @syntaxes = CodeBlock.syntaxes :all, :order => 'language ASC'
  end
end