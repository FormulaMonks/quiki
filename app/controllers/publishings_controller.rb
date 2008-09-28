class PublishingsController < ApplicationController
  before_filter :create_destination, :only => :create
  
  def new
    @version = Page::Version.find params[:page_version_id]
    @page = @version.page
    @publishing = Publishing.new
  end
  
  def create
    page_version = Page::Version.find params[:page_version_id]
    destinations = destination_ids? ? Destination.find(destination_ids) : []
    destinations << @destination if create_destination?
    
    if destinations.empty?
      flash[:error] = 'Nothing seleted to publish to.'
    else
      destinations.each do |destination|
        publishing = destination.publishings.create :page_version => page_version
        flash[:success]
      end
    end
    
    redirect_to :back
  end
  
  private
    def create_destination
      return unless create_destination?
      if (@destination = Destination.create(params[:destination])).new_record?
        append_errors_from @destination
        redirect_to :back and return
      end
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