class PublishingsController < ApplicationController
  def new
    @version = Page::Version.find params[:page_version_id]
    @page = @version.page
    @publishing = Publishing.new
  end
  
  def create
    page_version = Page::Version.find params[:page_version_id]
    destinations = destination_ids? ? Destination.find(destination_ids) : []
    destinations << create_destination if create_destination?
         
    destinations.each do |destination|
      destination.publishings.create :page_version => page_version
    end
    
    redirect_to :back
  end
  
  private
    def create_destination
      unless destination = Destination.create(params[:destination])
        append_errors_from destination
        redirect_to :back and return
      end
      destination
    end
  
    def create_destination?
      params[:create_destination]
    end
    
    def destination_ids
      params[:publishing].delete(:destination).reject{ |id| id.blank? }
    end
    
    def destination_ids?
      params[:publishing] && params[:publishing][:destination]
    end
end