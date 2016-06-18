Rails.application.routes.draw do
  root 'books#index'
  resources :books

  # namespace :api, path: '/', constraints: { subdomain: 'api'}  do TODO non riesco a farlo funzionare :\
  namespace :api do
    resources :books
  end
end
