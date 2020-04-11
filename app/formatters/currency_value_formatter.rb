class CurrencyValueFormatter < JSONAPI::ValueFormatter
  class << self
    def format(raw_value)
      case raw_value
        when Money
          return {
            currency: raw_value.currency.iso_code,
            value: raw_value.fractional,
            display: raw_value.format
          }
        else
          return raw_value
      end
    end

    def unformat(value)
      # We expect an object from the request (ActionController::Parameters in runtime)
      # when we don't get the expected format, pass the value as is, for ActiveRecord to validate
      case value
        when ActionController::Parameters
          return Money.new value['value'], value['currency']
        else
          return value
      end
    end
  end
end
