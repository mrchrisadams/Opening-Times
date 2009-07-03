ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  map.root :controller => 'about', :action => 'homepage'
#  map.resources :facilities, :as => 'f'

  map.resources :facilities, :as => 'f' do |services|
    services.resources :revisions
    services.resources :facility_slug_traps, :as => :slugs
  end

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.resources :user_sessions
  map.resources :users

  map.connect 'compare/:a/:b', :controller => 'compare'

  %w(about accessibility bankholidays copyright faq feedback license privacy recentchanges sitemap statistics).each do |a|
    map.send "#{a}", "#{a}", :controller => 'about', :action => a
    map.send "#{a}", "#{a}.:format", :controller => 'about', :action => a
  end

  map.search 'search/:action', :controller => 'search'
#  map.fireeagle 'search/fireeagle', :controller => 'search', :action => 'fireeagle'

  map.facility_slug ':slug', :controller => 'slug_trap', :action => 'show'

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
