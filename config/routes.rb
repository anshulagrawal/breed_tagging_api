Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/breeds/stats', to: 'stats#breeds'
  get '/tags/stats', to: 'stats#tags'
  get '/breeds/:breed_id/tags', to: 'tags#show_by_breed'
  post '/breeds/:breed_id/tags', to: 'tags#create'
  resources :breeds, only: [:index, :show, :update, :destroy, :create]
  resources :tags, only: [:index, :show, :update, :destroy]
end
