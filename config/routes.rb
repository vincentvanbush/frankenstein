Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users, skip: [:registrations]
  devise_for :admins, skip: [:sessions, :registrations, :passwords]
  devise_for :patients, skip: [:sessions, :passwords]
  devise_for :doctors, skip: [:sessions, :passwords]

  resources :users, only: [:index]
  resources :doctors, only: [:index, :show, :edit, :update] do
    resources :assignments, only: [:new, :create, :destroy]
  end

end
