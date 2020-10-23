# frozen_string_literal: true

Spree::Core::Engine.add_routes do
  resources :wishlists
  resources :wished_products, only: %i[create update destroy]
  get '/wishlist' => 'wishlists#default', as: 'default_wishlist'
  get '/wishlist_mini' => 'wishlists#mini', as: 'wishlist_mini'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :wishlists
      resources :wished_products, only: %i[create update destroy]
    end
  end
end
