module RSpec
  module NcmaApi
    module RequestHelpers
      def headers
        _default_headers.clone
      end

      [:post, :put, :patch].each do |method_name|
        define_method method_name do |path, body, additional_headers = {}|
          super(
            path,
            params: body,
            headers: headers.merge(additional_headers),
            as: :json
          )
        end
      end

      [:post, :put, :patch].each do |action|
        define_method :"#{action.to_s}_as" do |role, *args|
          token = _build_token_for(role)
          send(action, *args, { Authorization: "Bearer #{token}" })
        end
      end

      def _default_headers
        {
          Accept: 'application/vnd.api+json',
          'Content-Type': 'application/vnd.api+json'
        }
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::NcmaApi::RequestHelpers, :type => :request
end