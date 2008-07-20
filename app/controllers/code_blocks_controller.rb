class CodeBlocksController < ApplicationController
  def index
    @code_blocks = CodeBlock.current.find :all, :conditions => [ 'code_blocks.language = ?', filter ], :page => page_options
  end
  
  def show
    code = CodeBlock.find params[:id], :include => :page, :conditions => [ 'pages.path = ?', params[:path] ]
    render :text => code.code, :content_type => 'text/plain'
  end
  
  def filter
    params[:filter]
  end
  helper_method :filter
end