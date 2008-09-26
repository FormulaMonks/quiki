ActionController::Routing::Routes.draw do |map|
  map.with_options :path_prefix => '/tools' do |tools|
    tools.parser 'parsers/:parser', :controller => 'parsers', :action => 'show', :parser => '/[a-z0-9\-_]+/', :conditions => { :method => :get }
    tools.resources :sections
    tools.resources :page_versions, :has_many => :publishings
    tools.resources :pages, :has_many => :versions
    tools.resources :code_blocks
    tools.resources :syntaxes
    tools.resources :destinations
  end
  
  map.with_options :controller => 'pages', :path => /#{Page::PATH_REGEX}/ do |pages|
    { :get => 'show', :put => 'update', :delete => 'destroy' }.each do |method, action|
      pages.page '/:path', :action => action, :conditions => { :method => method }
    end
    pages.edit_page '/:path/edit', :action => 'edit'
  end
  
  map.page_source '/:path/code/:id', :controller => 'code_blocks', :action => 'show', :path => /#{Page::PATH_REGEX}/, :id => /\d+/
  
  map.root :controller => 'pages', :action => 'show', :path => 'Home'
end
