Rails.application.routes.draw do
  get 'users/new'

  root                      'static_pages#home'
  get    'help'          => 'static_pages#help'
  get    'link'          => 'static_pages#link'
  get    'about'         => 'static_pages#about'
  get    'contact'       => 'static_pages#contact'
  get    'signup'        => 'users#new'
  get    'login'         => 'sessions#new'
  post   'login'         => 'sessions#create'
  delete 'logout'        => 'sessions#destroy'
  patch  'attend_update' => 'attendances#attend_update'
  get    'attend_edit'   => 'attendances#attend_edit'
  get    'work'          => 'attendances#work'
  get    'basic_info'    => 'attendances#basic_info'
  patch  'ba_info_edit'  => 'attendances#ba_info_edit'
  # get    '/attendances/attend_edit' => 'users#show'
  # get    'attend_update' => 'users#show'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  # resources :attendances
end