module AuthorizationHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :handle_pundit_error

    private

    def handle_pundit_error(error)
      render json: { error: 'Forbidden', message: error.message }, status: 403
    end
  end
end