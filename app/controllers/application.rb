class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  layout 'page_menu_layout'
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  
  before_filter :initialize_page_menu
  
  def site_config(key)
    SITE_CONFIG[key.to_s]
  end
  helper_method :site_config
  
  def append_message(message, type=:error, now=false)
    stack = now ? flash.now : flash
    stack[type] ||= []
    stack[type] << message
  end
  
  def append_error(message, now=false)
    append_message message, :error
  end
  
  def append_success(message, now=false)
    append_message message, :success
  end
  
  def append_errors_from(model, now=false)
    now ? flash.now[:error] = model.errors.full_messages : flash[:error] = model.errors.full_messages
  end
  
  protected
    def page_options(options={})
      { :size => 10, :current => params[:page] }.merge(options)
    end
  
    def initialize_page_menu
      # prefix with base_ so there's less chance of interfering with usage in
      # other controllers
      @base_orphaned_pages = Page.orphaned.without_home
      @base_sections = Section.find(:all, :conditions => [ 'pages.id IS NULL OR path <> ?', 'Home' ], :include => :pages, :order => 'LOWER(sections.name) ASC, LOWER(pages.path) ASC')
    end
end
