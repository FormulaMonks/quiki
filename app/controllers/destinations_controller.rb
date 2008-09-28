class DestinationsController < ApplicationController
  def index
    @destinations = Destination.find(:all)
  end
  
  def create
    @destination = Destination.new params[:destination]
  
    if @destination.save
      flash[:success] = "#{@destination} is now available for publishing."
      redirect_to 'index'
    else
      flash.now[:error] = "Failed to save #{@destination}."
      render :action => :index
    end
  end
  
  def destroy
    if (@destination = Destination.find(params[:id])).destroy
      flash[:success] = "#{@destination} deleted successfully."
    else
      flash[:error] = "Failed to delete #{@destination}."
    end
    redirect_to :back
  end
end