Rails.application.routes.draw do
  resources :reportcells
  resources :reports
  resources :notifications
  resources :requests
  resources :users
  resources :collections
  resources :residues
  resources :laboratories
  resources :departments
  resources :registers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
