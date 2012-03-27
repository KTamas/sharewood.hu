Planet::Application.routes.draw do 
  get "users/new"

  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :feed_urls
  resources :users

  match 'search' => 'pages#search'
  match 'sharewood_opml' => 'pages#opml', :as => :xml
  match 'about' => 'pages#about'
  match '/:page' => 'pages#index'

  # compatibility
  match '/feed.rss' => redirect('/index.rss')

  root :to => "pages#index"
end
