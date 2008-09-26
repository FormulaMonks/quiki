class DestinationsController < ApplicationController
  def index
    @destinations = Destination.find(:all)
  end
  
  def create
    @destination = Destination.new params[:destination]
  
    if @destination.save
      flash[:success] = "#{@destination.name} is now available for publishing."
      redirect_to 'index'
    else
      flash.now[:error] = "Failed to save #{@destination.name}."
      render :action => :index
    end
  end
end