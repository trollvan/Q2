Rails.application.routes.draw do
  devise_for :users, skip: [:sessions]

  namespace :users do
    resource :actions, only: :create
  end
  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
