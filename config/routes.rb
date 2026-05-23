Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  resources :projects, only: [:index, :show] do
    member { get :gallery }
    resources :construction_records, except: [:index]
    resources :estimates, except: [:index] do
      member do
        patch :extend_share
        get :print
      end
    end
    resources :ws_logs, except: [:index]
    resources :receipts, except: [:index] do
      member { patch :extend_share }
    end
    resources :invoices, except: [:index] do
      member { patch :extend_share }
    end
  end
  get "documents", to: "estimates#index", as: :documents
  get "estimates", to: redirect("/documents")
  get "e/:token", to: "estimates#public_show", as: :public_estimate
  get "e/:token/print", to: "estimates#public_print", as: :public_estimate_print
  get "i/:token", to: "invoices#public_show", as: :public_invoice
  get "r/:token", to: "receipts#public_show", as: :public_receipt

  get "up" => "rails/health#show", as: :rails_health_check

  root "projects#index"
end
