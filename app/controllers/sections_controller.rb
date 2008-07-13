class SectionsController < ApplicationController
  before_filter :new_section, :only => [ :create ]
  before_filter :find_section_by_id, :only => [ :destroy, :update ]
  
  def create
    respond_to do |format|
      if @section.save
        format.html do
          flash[:success] = "Added section #{@section}"
          redirect_back_or_default '/'
        end
        format.json { render :json => { :html => @section }, :status => :ok }
      else
        format.html do
          flash[:error] = @section.errors.full_messages
          render :action => 'new'
        end
        format.json { render :json => { :errors => @section.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @section.update_attributes params[:section]
    
    respond_to do |format|
      if @section.save
        format.html do
          flash[:success] = "#{@section} updated"
          redirect_back_or_default '/'
        end
        format.json { render :json => { :html => @section }, :status => :ok }
      else
        format.html do
          flash[:error] = @section.errors.full_messages
          render :action => 'edit'
        end
        format.json { render :json => { :errors => @section.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @section.destroy
    redirect_back_or_default '/'
  end
  
  private
    def new_section
      @section = Section.new params[:section]
    end
  
    def find_section_by_id
      @section = Section.find(params[:id])
    end
end