Rails.application.routes.draw do
  root "pages#home"
  resources :clinics, only: [:index, :show]
  get '/find-a-clinic', to: 'clinics#index'
end