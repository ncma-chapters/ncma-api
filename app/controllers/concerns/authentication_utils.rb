module AuthenticationUtils
  extend ActiveSupport::Concern

  included do

    private

    def get_user_context
      # Continue without raising JWT::DecodeError, let authorization handle the error
      return nil if request.authorization.nil?

      unparsed_token = request.authorization.split('Bearer ')[1]

      token_payload, token_header = if Rails.env.test?
        JWT.decode(unparsed_token, Rails.configuration.jwt_secret, true, { algorithm: 'HS256' })
      else
        JWT.decode(unparsed_token, nil, true, { algorithms: ['RS256'], jwks: jwks_loader })
      end

      RequestContext::User.new token_payload
    rescue JWT::DecodeError => e
      Rails.logger.info e
      raise e
    rescue Exception => e
      Rails.logger.error e
      raise e
    end

    def jwks_loader
      ->(options) do
        @cached_jwks = nil if options[:invalidate]
        @cached_jwks ||= fetch_jwks_keys
      end
    end

    def fetch_jwks_keys
      user_pool_id = Rails.configuration.auth[:user_pool_id]

      raise 'Rails.configuration.auth.user_pool_id is required' if user_pool_id.nil?

      response = Net::HTTP.get(
        URI("https://cognito-idp.us-east-1.amazonaws.com/#{user_pool_id}/.well-known/jwks.json")
      )

      JSON.parse(response).with_indifferent_access
    end
  end
end
