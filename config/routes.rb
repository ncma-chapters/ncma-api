Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  jsonapi_resources :events do
    # Remove block to allow nested routes (i.e. /events/:id/venue) 
  end
end
