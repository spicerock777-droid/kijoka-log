Rails.application.routes.draw do
  devise_for :users
  resources :projects, only: [:index, :show] do
    resources :construction_records, except: [:index]
    resources :estimates, except: [:index]
    resources :ws_logs, except: [:index]
    resources :receipts, except: [:index]
    resources :invoices, except: [:index]
  end
  get "documents", to: "estimates#index", as: :documents
  get "estimates", to: redirect("/documents")
  get "e/:token", to: "estimates#public_show", as: :public_estimate

  get "up" => "rails/health#show", as: :rails_health_check

  root "projects#index"
end
