Rails.application.routes.draw do
  root 'questions#index'

  resources :questions do
    resources :answers, only: [:index, :create, :update]
  end
  # resources :answers, only: [:update]
end
