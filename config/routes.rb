ActionController::Routing::Routes.draw do |map|
  map.resources :pages, :has_many => :versions
  { :get => 'show', :put => 'update', :delete => 'destroy' }.each do |method, action|
    map.page '/:path', :controller => 'pages', :action => action, :path => /#{Page::PATH_REGEX}/, :conditions => { :method => method }
  end
  map.edit_page '/:path/edit', :controller => 'pages', :action => 'edit', :path => /#{Page::PATH_REGEX}/
  map.page_source '/:path/code/:id', :controller => 'code_blocks', :action => 'show', :path => /#{Page::PATH_REGEX}/, :id => /\d+/
  map.resources :sections
  map.parser '/parsers/:parser', :controller => 'parsers', :action => 'show', :parser => '/[a-z0-9\-_]+/'
  map.root :controller => 'pages', :action => 'show', :path => 'Home'
end
