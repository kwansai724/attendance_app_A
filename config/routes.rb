Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get  '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :bases

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'working_index'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/edit_overtime_apply'
      patch 'attendances/update_overtime_apply'
      get 'edit_overtime_approval'
      patch 'update_overtime_approval'
    end
    resources :attendances, only: :update
    collection { post :import }
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
