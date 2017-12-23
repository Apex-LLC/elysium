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
end
