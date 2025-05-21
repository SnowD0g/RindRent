Rails.application.routes.draw do
  root 'loaned_items#index'
  resources :loaned_items do
    patch :mark_as_returned, on: :member
  end

  # namespace :api, path: '/', constraints: { subdomain: 'api'}  do TODO non riesco a farlo funzionare :\
  namespace :api do
    resources :loaned_items # This remains unchanged for the API, as the new action is UI-specific
  end
end
