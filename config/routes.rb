Rails.application.routes.draw do
  root to: "users#show"

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

  #api
  namespace :api do
    namespace :v1 do
      resources :sessions, only: [:create, :show]
      resources :users, only: [:show] 
      get 'meters', to: 'users#meters'
      post 'meters', to: 'meters#import'
      post 'records', to: 'records#import'
      resources :billable_meters, only: [:index]
      resources :records, only: [:create]
    end
  end  
end
