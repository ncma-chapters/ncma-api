module RSpec
  module NcmaApi
    module RequestHelpers
      JWT_SECRET = 'secret'

      attr_reader :user_context

      def _build_token_for(groups)
        groups = groups.instance_of?(Array) ? groups : [groups]
        groups = groups.map do |group_symbol|
          _user_group_map[group_symbol] || raise(ArgumentError, 'No user group found for this group_symbol')
        end

        user_id = SecureRandom.uuid
        now = DateTime.now

        payload = {
          'sub' => user_id,
          'email_verified' => true,
          'iss' => 'https://cognito-idp.us-east-1.amazonaws.com/us-east-1_AbcXyz',
          'cognito:username' => user_id,
          'given_name' => Faker::Name.first_name,
          'aud' => '4uqn4v07s9or8tbbb9ku9eqs0i',
          'event_id' => SecureRandom.uuid,
          'token_use' => 'id',
          'auth_time' => now.to_i,
          'exp' => (now + 1.hour).to_i,
          'iat' => now.to_i,
          'family_name' => Faker::Name.last_name,
          'email' => Faker::Internet.email
        }

        payload['cognito:groups'] = groups if groups.any?

        @user_context = RequestContext::User.new(payload)

        JWT.encode payload, JWT_SECRET, 'HS256' 
      end

      def _user_context=(payload)
        binding.pry
        
      end

      def _user_group_map
        { event_manager: 'EventManagers' }
      end
    end
  end
end
