Rails.application.routes.draw do
  devise_for :users
  resources :projects, only: [:index, :show] do
    resources :construction_records, except: [:index]
    resources :estimates, except: [:index]
  end
  get "estimates", to: "estimates#index", as: :estimates
  get "e/:token", to: "estimates#public_show", as: :public_estimate

  get "up" => "rails/health#show", as: :rails_health_check

  root "projects#index"
end
