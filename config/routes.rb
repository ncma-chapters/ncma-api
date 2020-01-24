Rails.application.routes.draw do
  jsonapi_resources :events do
    # Remove block to allow nested routes (i.e. /events/:id/venue)
    jsonapi_resources :ticket_classes do

    end
  end
end
