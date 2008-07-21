class CodeBlocksController < ApplicationController
  def index
    @code_blocks = CodeBlock.current.find :all, :conditions => [ 'code_blocks.language = ?', filter ], :order => 'code_blocks.created_at DESC', :page => page_options
    
    respond_to do |format|
      format.html {}
    end
  end
  
  def show
    code = CodeBlock.find params[:id], :include => :page, :conditions => [ 'pages.path = ?', params[:path] ]
    render :text => code.code, :content_type => 'text/plain'
  end
  
  def filter
    params[:filter] || CodeBlock.syntaxes(:first, :order => 'cnt DESC').syntax
  end
  helper_method :filter
end