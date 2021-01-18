Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  resources :users

  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
