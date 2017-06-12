Rails.application.routes.draw do
  resources :reportregs
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
  
  root 'application#index'
  
  get '/main_fac', to: 'application#main_fac'
  get '/main_adm', to: 'application#main_adm'
  get '/genarate_report', to: 'application#genarate_report'
  get '/statistic', to: 'application#statistic'
  get '/request', to: 'application#request'
  get '/account', to: 'application#account'
end
