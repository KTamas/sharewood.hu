Planet::Application.routes.draw do 
  # The priority is based upon order of creation:
  # first created -> highest priority.

  match 'search' => 'pages#search'
  match 'sharewood_opml' => 'pages#opml', :as => :xml
  match 'about' => 'pages#about'
  match '/:page' => 'pages#index'

  # compatibility
  match '/feed.rss' => redirect('/index.rss')

  resources :feed_urls
  root :to => "pages#index"
end
