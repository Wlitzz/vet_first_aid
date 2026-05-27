Rails.application.routes.draw do
  root "pages#home"
  resources :clinics, only: [:index, :show]
  get '/find-a-clinic', to: 'clinics#index'

  get  '/quiz',         to: 'quiz#index',  as: :quiz
  get  '/quiz/:topic',  to: 'quiz#show',   as: :quiz_topic
  post '/quiz/:topic',  to: 'quiz#result', as: :quiz_result
end