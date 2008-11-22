ActionController::Routing::Routes.draw do |map|
  map.with_options :path_prefix => '/tools' do |tools|
    tools.with_options :controller => 'parsers', :action => 'show', :parser => '/[a-z0-9\-_]+/', :conditions => { :method => :get } do |parsers|
      parsers.parser 'parsers/:parser'
      parsers.formatted_parser 'parsers/:parser.:format'
    end
    tools.resources :sections
    tools.resources :page_versions, :has_many => :publishings
    tools.resources :pages, :has_many => :versions
    tools.resources :code_blocks
    tools.resources :syntaxes
    tools.resources :destinations
    tools.resources :assets
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
