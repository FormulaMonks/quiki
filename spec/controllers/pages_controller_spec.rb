require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "route generation" do
    it "should map { :controller => 'pages', :action => 'show', :path => 'foobar' } to /foobar" do
      route_for(:controller => "pages", :action => "show", :path => 'foobar').should == "/foobar"
    end
    
    it "should map { :controller => 'pages', :action => 'destroy', :path => 'foobar' } to /foobar" do
      route_for(:controller => "pages", :action => "destroy", :path => 'foobar').should == "/foobar"
    end

    it "should map { :controller => 'pages', :action => 'edit', :path => 'foobar' } to /foobar/edit" do
      route_for(:controller => "pages", :action => "edit", :path => 'foobar').should == "/foobar/edit"
    end
  end

  describe "route recognition" do
    it "should generate params { :controller => 'pages', action => 'show', :path => 'foobar' } from GET /foobar" do
      params_from(:get, "/foobar").should == {:controller => "pages", :action => "show", :path => "foobar"}
    end

    it "should generate params { :controller => 'pages', action => 'destroy', :path => 'foobar' } from DELETE /foobar" do
      params_from(:delete, "/foobar").should == {:controller => "pages", :action => "destroy", :path => "foobar"}
    end

    it "should generate params { :controller => 'pages', action => 'edit', :path => 'foobar' } from GET /foobar/edit" do
      params_from(:get, "/foobar/edit").should == {:controller => "pages", :action => "edit", :path => "foobar"}
    end
  end

  describe "handling GET /foobar" do
    before do
      @page = mock_model(Page)
      Page.stub!(:find).and_return(@page)
    end
  
    def do_get
      get :show
    end
  end
  
  describe "handling POST /pages" do
    before do
      @page = mock_model(Page, :save => true)
      Page.stub!(:new).and_return(@page)
    end
  
    def do_post(params={})
      post :create, { :path => 'foobar' }.merge(params)
    end
    
    it "should redirect to edit on succesful save" do
      do_post
      response.should redirect_to(edit_page_path(@page))
    end

    it "should render new on failed save" do
      @page.stub!(:save).and_return(false)
      do_post
      response.should render_template('pages/new')
    end
  end  
end