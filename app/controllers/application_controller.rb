class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController
  include AuthenticationUtils
  include AuthorizationHandler

  abstract

  def context
    RequestContext.new(user: get_user_context)
  end
end
