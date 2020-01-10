Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Remove block to allow nested routes (i.e. /events/:id/venue)
  jsonapi_resources :events do
 
  end
end
