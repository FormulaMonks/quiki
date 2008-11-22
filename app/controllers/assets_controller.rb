class AssetsController < ApplicationController
  def index
    @assets = Asset.find(:all)
    
    respond_to do |format|
      format.tab { render :template => 'assets/index.html.haml', :layout => false }
    end
  end
end