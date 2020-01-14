class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController

  abstract
end