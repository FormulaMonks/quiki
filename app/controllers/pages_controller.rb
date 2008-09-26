class PagesController < ApplicationController
  before_filter :store_location
  before_filter :new_page, :only => [ :new, :create ]
  before_filter :find_page_by_path, :only => [ :show, :edit, :destroy, :update ]
  
  def new
  end
  
  def index
    @pages = Page.recent.find(:all, :limit => 25)
    
    respond_to do |format|
      format.tab  { render :partial => 'pages/page_menu.html.haml', :layout => false }
      format.html {}
    end
  end
  
  def show
    if @page
      @version = @page.current
    else
      redirect_to new_page_path(:page => { :path => params[:path] }) and return
    end
  end
  
  def edit
    render :layout => 'pages/edit_layout.html.haml'
  end
  
  def create
    respond_to do |format|
      if @page.save
        format.html do
          flash[:success] = "Added page #{@page}"
          redirect_to edit_page_path(@page)
        end
        format.json { render :json => { :html => @page.rendered }, :status => :ok }
      else
        format.html do
          flash[:error] = @page.errors.full_messages
          render :action => 'new'
        end
        format.json { render :json => { :errors => @page.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    if params[:page][:version]
      @page.revert_to params[:page][:version]
    else
      @page.attributes = params[:page]
    end

    respond_to do |format|
      if @page.save
        format.html do
          flash[:success] = "#{@page} updated"
          redirect_to @page
        end
        format.json { render :json => { :html => @page.rendered }, :status => :ok }
      else
        format.html do
          flash[:error] = @page.errors.full_messages
          render :action => 'edit', :layout => 'pages/edit_layout.html.haml'
        end
        format.json { render :json => { :errors => @page.errors.full_messages }, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @page.destroy
    redirect_to '/'
  end
  
  private
    def new_page
      @page = Page.new params[:page]
    end
  
    def find_page_by_path
      @page = Page.find_by_path(params[:path])
    end
end