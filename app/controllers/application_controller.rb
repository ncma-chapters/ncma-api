class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController
  include AuthenticationUtils

  abstract

  rescue_from Pundit::NotAuthorizedError, with: :handle_pundit_error
  rescue_from JWT::DecodeError, with: :handle_jwt_error

  def context
    RequestContext.new(user: get_user_context)
  end

  private

  def handle_pundit_error(error)
    render json: { error: 'Forbidden', message: error.message }, status: 403
  end

  def handle_jwt_error(error)
    case error
    when JWT::ExpiredSignature
      render json: { error: 'Unauthorized', message: error.message, type: error.class.to_s }, status: 401
    when JWT::DecodeError
      render json: { error: 'Unauthorized' }, status: 401
    end
  end
end
