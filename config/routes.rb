Rails.application.routes.draw do
  root 'root#welcome'
  get '/callback',          to: 'root#callback'
  resources :calculations,  only: [:index]
  get '/count_by_stars',    to: 'calculations#count_by_stars'
end
