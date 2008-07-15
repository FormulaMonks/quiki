class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  layout 'page_menu_layout'
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  
  before_filter :initialize_page_menu
  
  protected
    def initialize_page_menu
      # prefix with base_ so there's less chance of interfering with usage in
      # other controllers
      @base_orphaned_pages = Page.orphaned.without_home
      @base_sections = Section.find(:all, :conditions => [ 'pages.id IS NULL OR path <> ?', 'Home' ], :include => :pages, :order => 'LOWER(sections.name) ASC, LOWER(pages.path) ASC')
    end
end
