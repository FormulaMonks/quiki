class CodeBlocksController < ApplicationController  
  def show
    code = CodeBlock.find params[:id], :include => :page, :conditions => [ 'pages.path = ?', params[:path] ]
    render :text => code.code, :content_type => 'text/plain'
  end
end