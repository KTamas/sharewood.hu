Planet::Application.routes.draw do
  get "users/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :feeds
  resources :users do
    member do
      get :hide, :unhide
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]
  resources :hidden_feeds, only: [:create, :destroy]

  match '/hide/:id', :to => 'hidden_feeds#create'
  match '/unhide/:id', :to => 'hidden_feeds#destroy'

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match 'search' => 'pages#search'
  match 'sharewood_opml' => 'pages#opml', :as => :xml
  match 'about' => 'pages#about'

  match '/custom_rss/:secret_rss_key' => "pages#custom_rss"

  match '/:page' => 'pages#index'

  # compatibility
  match '/feed.rss' => redirect('/index.rss')

  root :to => "pages#index"
end
