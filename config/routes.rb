Rails.application.routes.draw do
  # TODO: add spec to verifiy routes don't get leaked
  jsonapi_resources :events do
    # Remove block to allow nested routes (i.e. /events/:id/venue)
    jsonapi_resources :ticket_classes do

    end
  end

  jsonapi_resources :event_registrations, only: [:create] do

  end
end
