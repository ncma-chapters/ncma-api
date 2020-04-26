class RequestContext
  class User
    attr_reader :original_payload

    def initialize(id_token_payload)
      @original_payload = id_token_payload
    end

    def id
      original_payload['sub']
    end

    def expires_at
      Time.at(original_payload['exp']).to_datetime
    end

    def issued_at
      Time.at(original_payload['iat']).to_datetime
    end

    def groups
      original_payload['cognito:groups'] || []
    end

    def in_group(group_name)
      groups.include?(group_name)
    end
  end
end
