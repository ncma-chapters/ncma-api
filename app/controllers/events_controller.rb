class EventsController < ApplicationController
  def index
    jsonapi_render json: Event.published
  end
end
