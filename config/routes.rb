Rails.application.routes.draw do
  # TODO: add spec to verifiy routes don't get leaked
  jsonapi_resources :events, only: [:index, :show, :create, :update] do
  # jsonapi_resources :events do
    # Remove block to allow nested routes (i.e. /events/:id/venue)
    jsonapi_resources :ticket_classes, only: [:index, :show] do

    end
  end

  jsonapi_resources :event_registrations, only: [:create] do

  end
end
