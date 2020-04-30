Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # resources :merchants, except: [:edit, :update, :delete]

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"

  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"

  resources :merchants, only: [:show] do
    resources :items, only: [:index, :new, :create]
  end

  # get "/merchants/:merchant_id/items", to: "items#index"
  # get "/merchants/:merchant_id/items/new", to: "items#new"
  # post "/merchants/:merchant_id/items", to: "items#create"

  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy]

  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  # resources :cart

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch "/cart/:item_id/increment", to: "cart#increment"
  patch "/cart/:item_id/decrement", to: "cart#decrement"

  resources :orders, except: [:index, :show]

  resource :profile, only: [:index] do
    resources :orders, only: [:show]
  end

  # get "/orders/new", to: "orders#new"
  # get "/profile/orders/:id", to: "orders#show"
  # patch "/orders/:id", to: "orders#update"
  # post "/orders", to: "orders#create"
  # delete "/orders/:id", to: "orders#destroy"

  get '/register', to: "users#new"
  post '/register', to: "users#create"

  namespace :user do
    get '/profile', to: "users#profile"
    get '/profile/edit', to: 'users#edit'
    patch '/profile', to: 'users#update'
    post '/profile', to: 'sessions#create'
    get "/profile/orders", to: "users#orders"
  end

  resources :bulk_discounts

  resource :password, only: [:edit, :update]

  namespace :merchant do
    # get '/merchants/:id/edit', to: 'merchants#edit'
    # patch '/merchants/:id', to: 'merchants#update'
    # delete '/merchants/:id', to: 'merchants#destroy'

    # get '/', to: "dashboard#index"
    # get '/orders/:id', to: "dashboard#show"

    get '/:merchant_id/items', to: "items#index"
    get '/items/new', to: "items#new"
    get '/items/:item_id/edit', to: "items#edit"
    post '/items', to: "items#create"
    patch '/items/:item_id/status', to: "items#status"
    patch '/items/:order_id/:item_id/fulfillment', to: "items#fulfill"
    patch '/items/:item_id', to: "items#update"
    delete '/items/:item_id', to: "items#destroy"
  end

  namespace :merchant do
    resources :merchants, only: [:edit, :update, :destroy]
    root to: 'dashboard#index'
    resources :dashboard, only: [:show], path: '/orders'
  end

  # get '/login', to: 'sessions#new'

  # couldnt figure out this one
  get '/logout', to: 'users#logout'

  resources :sessions, only: [:new], path_names: {new: '/login'}, path: '/'

  # namespace :admin do
    # get '/', to: 'dashboard#index'
    # get '/users', to: 'users#user_names'
    # get '/users/:user_id', to: 'users#show'
    # patch '/users/:user_id/disable', to: 'users#disable'
    # patch '/users/:user_id/enable', to: 'users#enable'
    # get '/merchants/:merchant_id', to: 'merchant#show'
    # get '/merchants', to: 'merchant#index'
    # patch '/merchant/:merchant_id/disable', to: 'merchant#disable'
    # patch '/merchant/:merchant_id/enable', to: 'merchant#enable'
    # get "users/:user_id/orders/:order_id", to: "orders#show"
  # end

  namespace :admin do
    root to: 'dashboard#index'
    resources :users, only: [:show] do
      patch :disable
      patch :enable
      root to: 'users#user_names'
      resources :orders, only: [:show]
    end
    resources :merchant, only: [] do
      patch :disable
      patch :enable
    end
    resources :merchant, only: [:index, :show], path: '/merchants'
  end

end
