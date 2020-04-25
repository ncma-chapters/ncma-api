module RequestContext
  class Context
    class User
      attr_reader :original_payload

      def initialize(id_token_payload)
        @original_payload = id_token_payload
      end

      def expires_at
        Time.at(original_payload[:exp]).to_datetime
      end

      def issued_at
        Time.at(original_payload[:iat]).to_datetime
      end

      def sub
        original_payload[:sub]
      end
    end
  end
end