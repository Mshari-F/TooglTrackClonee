Rails.application.routes.draw do
  resources :tasks
  resources :projects
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
 end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post '/tasks/:id/play', to: 'tasks#play', as:'task_play'
  post '/tasks/:id/stop', to: 'tasks#stop', as:'task_stop'

  # Defines the root path route ("/")
  #root "application#index"
  root "projects#index"
end
