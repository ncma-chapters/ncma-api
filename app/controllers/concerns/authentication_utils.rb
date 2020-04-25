module AuthenticationUtils
  extend ActiveSupport::Concern

  included do
    private

    def get_user_context
      auth_token = request.authorization.split('Bearer ')[1]

      id_token = if Rails.env.test?
        JWT.decode(auth_token, Rails.configuration.jwt_secret, true, { algorithm: 'HS256' })
      else
        JWT.decode(auth_token, nil, true, { algorithms: ['RS256'], jwks: jwks_loader })
      end

      RequestContext::Context::User.new(id_token)
    rescue Exception => e
      nil
    end

    def jwks_loader
      ->(options) do
        @cached_jwks = nil if options[:invalidate]
        @cached_jwks ||= fetch_jwks_keys
      end
    end

    def fetch_jwks_keys
      user_pool_id = Rails.configuration.auth.user_pool_id

      raise 'Rails.configuration.auth.user_pool_id is required' if user_pool_id.nil?

      response = Net::HTTP.get(
        URI("https://cognito-idp.us-east-1.amazonaws.com/#{user_pool_id}/.well-known/jwks.json")
      )

      JSON.parse(response).with_indifferent_access
    end
  end
end
