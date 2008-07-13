class ParsersController < ApplicationController
  layout nil
  
  def show
    respond_to do |format|
      format.html { render :partial => "parsers/#{params[:parser]}" }
      format.json { render :json => { :html => render_to_string(:partial => "parsers/#{params[:parser]}.html.haml"), :parser => params[:parser].humanize } }
    end
  end
end