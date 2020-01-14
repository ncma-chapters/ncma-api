class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  abstract

  # rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found
  # rescue_from NotAuthorizedError, with: :reject_forbidden_request
end
