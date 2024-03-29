Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  resources :products
  resources :users
  resources :support_requests, only: %i[ index update ]
  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    # Defines the root path route ("/")
    root 'store#index', as: 'store_index', via: :all
  end  
 
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
