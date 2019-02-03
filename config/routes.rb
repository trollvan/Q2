# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             skip: %i[registrations passwords],
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  namespace :users do
    resource :actions, only: :create
    resource :registrations, only: %i[new create]
  end
  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
