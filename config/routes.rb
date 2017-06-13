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
  get '/creation', to: 'application#creation'
  get '/main_adm', to: 'application#main_adm'
  get '/genarate_report', to: 'application#genarate_report'
  get '/statistic', to: 'application#statistic'
  get '/requests', to: 'application#request'
  get '/account', to: 'application#account'
  get '/types', to: 'application#types'
  get '/often', to: 'application#often'
  get '/percent', to: 'application#percent'
  get '/generate_types', to: 'application#types'
  get '/generate_types_percent', to: 'application#percent'
  get '/generate_often', to: 'application#often'
  
  get '/accept_request', to: 'requests#accept_request'
  post '/accept_request', to: 'requests#accept_request'
  get '/refuse_request', to: 'requests#refuse_request'
  post '/refuse_request', to: 'requests#refuse_request'
  
end
