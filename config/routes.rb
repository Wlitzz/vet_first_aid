Rails.application.routes.draw do

  root "pages#home"

  resources :clinics, only: [:index, :show]
  get "/find-a-clinic", to: "clinics#index"

  # Quiz Routes
  get  "/quiz",        to: "quiz#index",  as: :quiz
  get  "/quiz/:topic", to: "quiz#show",   as: :quiz_topic
  post "/quiz/:topic", to: "quiz#result", as: :quiz_result

  # Authentication
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Registration
  get "/register", to: "users#new"
  post "/register", to: "users#create"

  # Profile
  get "/profile", to: "profiles#show"
  get "/profile/edit", to: "profiles#edit"
  patch "/profile", to: "profiles#update"

  # Pets
  resources :pets

end