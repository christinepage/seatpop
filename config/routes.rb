Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  resources :parties

  resources :restaurants

  get 'users/new'

  root              'static_pages#search'
  get 'help'    =>  'static_pages#help'
  get 'about'   =>  'static_pages#about'
  get 'contact' =>  'static_pages#contact'
  get 'search'  =>  'static_pages#search'
  get 'check_status'  =>  'static_pages#check_status'
  
  get 'search_results'  =>  'static_pages#search'
  get 'staff_home'  =>  'static_pages#staff_home'
  get 'signup'  =>  'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  resources :users
  resources :parties
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  
  get 'cancel_party' => 'parties#cancel_party'
  get 'drop_party' => 'parties#drop_party'
  get 'parties/:id/table_ready' => 'parties#table_ready'
  get 'parties/:id/notify' => 'parties#notify'
  get 'twilio/send_sms' => 'twilio#send_sms'
  get 'twilio/receive_sms' => 'twilio#receive_sms'


  post 'api/signup'
  post 'api/signin'
  post 'api/reset_password'

  get 'api/get_waitlist'
  post 'api/add_party'
  get 'get_restaurant'
  delete 'api/seat_party'  => 'parties#seat_party'
#  get 'api/get_restaurants'
    
  get 'api/get_token'  
  get 'api/clear_token'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
