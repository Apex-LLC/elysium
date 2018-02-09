Rails.application.routes.draw do
  resources :sites
  devise_for :users
  resources :users
  resources :payments
  resources :spaces do 
    member do
      get 'get_meters'
    end
  end
  resources :contacts
  resources :billable_meters
  resources :meters
  resources :invoices
  resources :tenants
  resources :records
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "users#show"

  #api
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show]
      resources :billable_meters, only: [:index]
      resources :records, only: [:create]
      resources :sessions, only: [:create]
    end
  end  
end
