Rails.application.routes.draw do

  devise_for :users, :controllers => {:confirmations => 'confirmations', :registrations => "registrations", :passwords => "passwords"}, :path => 'users', :path_names => {:sign_up => 'register', :sign_in => 'login'}
  
  devise_scope :user do
    patch "/confirm", to: "confirmations#confirm"
    get "users/show", to: "registrations#show", :as => "show_registration"
    get "users/password/show", to: "passwords#show", :as => 'show_reset_password'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_update'
    get "/users/password" => "registrations#change_password", :as => :change_password
  end
  

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "writing_challenges#daily_challenge"#{}"responses#new", :writing_challenge_id => '3'
  resources :writing_challenges do 
    resources :responses
  end
  
  resources :profiles
  get "history", to: 'writing_challenges#history'
  get "/users/check-unique-username", to: 'users#check_unique_username', as: :check_unique_username
  get "/users/check-if-email-confirmed", to: 'users#check_if_email_confirmed', as: :check_if_email_confirmed
  get "/users/check-if-email-exists", to: 'users#check_if_email_exists', as: :check_if_email_exists
  get "/users/password-match", to: 'users#password_match?', as: :password_match  
  get "/users/password-correct", to: 'users#password_correct?', as: :password_correct
  get "writing_challenges/history/:date", to: 'writing_challenges#re_history'
  get "daily_challenge", to: 'writing_challenges#daily_challenge', as: :daily_challenge
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
