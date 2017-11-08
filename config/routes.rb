Rails.application.routes.draw do
  devise_for :users
  get '/' =>'home#index', as: :root
  resources :jobs
  resources :bikes
  resources :users

  get 'logout' => "home#logout"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
