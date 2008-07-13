class VersionsController < ApplicationController
  before_filter :find_page_by_page_id
  
  def index
    @versions = @page.versions.find(:all, :order => 'updated_at DESC')
  end
  
  def show
    @version = @page.versions.find_by_version params[:id]
  end
  
  private
    def find_page_by_page_id
      @page = Page.find_by_path params[:page_id]
    end
end