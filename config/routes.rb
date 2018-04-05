Rails.application.routes.draw do
  resources :admin_costs
  resources :accounts
  resources :rates
  root to: "accounts#show"

  resources :sites
  devise_for :users, controllers: {registrations:'users/registrations'}
  resources :users
  resources :payments
  resources :charges
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
