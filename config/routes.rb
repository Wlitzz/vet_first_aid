Rails.application.routes.draw do
  root "pages#home"

  get "/triage", to: "first_aid_procedures#index", as: :triage
  resources :first_aid_procedures, only: [:show] do
    resources :steps, only: [:show]
  end

  namespace :admin do
    root to: "first_aid_procedures#index"
    resources :first_aid_procedures do
      resources :steps
      resources :instructional_videos, except: [:index, :show]
    end
  end
end
