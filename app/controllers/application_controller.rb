class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  abstract

  private

  def authorize_admin
  	head :forbidden
  end
end