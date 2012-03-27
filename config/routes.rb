Planet::Application.routes.draw do 
  get "users/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :feed_urls
  resources :users do
    member do
      get :subscribe, :unsubscribe
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]

  match '/subscribe/:id', :to => 'relationships#create'
  match '/unsubscribe/:id', :to => 'relationships#destroy'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match 'search' => 'pages#search'
  match 'sharewood_opml' => 'pages#opml', :as => :xml
  match 'about' => 'pages#about'
  match '/:page' => 'pages#index'

  # compatibility
  match '/feed.rss' => redirect('/index.rss')

  root :to => "pages#index"
end
