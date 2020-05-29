Rails.application.routes.draw do
  root to: redirect('/events')

  resources :health, only: [:index]

  # TODO: add spec to verifiy routes don't get leaked
  jsonapi_resources :venues, only: [:create, :update] do
  end

  jsonapi_resources :events, only: [:index, :show, :create, :update] do
    # Remove block to allow nested routes (i.e. /events/:id/venue)
    jsonapi_resources :ticket_classes, only: [:index, :show] do
    end

    jsonapi_resources :event_registrations, only: [:index] do
    end
  end

  jsonapi_resources :ticket_classes, only: [:create, :update] do
  end

  jsonapi_resources :event_registrations, only: [:create] do
  end

  post '/hooks/stripe' => 'hooks#stripe'
end
