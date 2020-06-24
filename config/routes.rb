Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications,
                     :authorized_applications
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api, defaults: { format: :json } do
    resources :musics
    resources :genres
    resources :albums
    resources :artists
    devise_for :users, controllers: { sessions: 'sessions' }
    devise_scope :user do
      get 'users/current', to: 'sessions#show'
    end
  end
end
