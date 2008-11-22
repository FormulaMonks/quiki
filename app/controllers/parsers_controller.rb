class ParsersController < ApplicationController
  layout 'parsers/layout'
  
  def show
    respond_to do |format|
      format.html { render :template => "parsers/#{params[:parser]}" }
      format.json { render :json => { :html => render_to_string("parsers/#{params[:parser]}.html.haml"), :parser => params[:parser].humanize } }
      format.tab  { render :template => "parsers/#{params[:parser]}.html.haml" }
    end
  end
end
