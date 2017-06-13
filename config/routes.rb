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
  get '/types', to: 'application#types'
  get '/often', to: 'application#often'
  get '/percent', to: 'application#percent'
  
  post '/generate_types', to: 'application#generate_types'
  post '/generate_types_percent', to: 'application#generate_types_percent'
  post '/generate_often', to: 'application#generate_often'
end
