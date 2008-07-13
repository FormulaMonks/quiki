class CodeBlocksController < ApplicationController  
  def show
    @page = Page.find_by_path params[:path]
    render :text => @page.code_blocks[params[:id].to_i].code, :content_type => 'text/plain'
  end
end