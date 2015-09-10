Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users, skip: [:registrations]
  devise_for :admins, skip: [:sessions, :registrations, :passwords]
  devise_for :patients, skip: [:sessions, :passwords],
             controllers: { registrations: 'devise_custom/patient_registrations' }
  devise_for :doctors, skip: [:sessions, :passwords],
             controllers: { registrations: 'devise_custom/doctor_registrations' }

  resources :users, only: [:index]
  resources :doctors, only: [:index, :show, :edit, :update] do
    # resources :assignments, only: [:new, :create, :destroy]
    resources :availabilities, only: [:new, :create, :destroy]
  end

  resources :assignments, only: [:index, :create, :destroy]

  resources :appointments, only: [:new, :create, :index, :destroy] do
    member do
      patch :cancel
      patch :confirm
    end
  end

  resources :clinics, only: [:new, :create, :edit, :update, :destroy, :index, :show]

end
