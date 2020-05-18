class Venue < ApplicationRecord
  has_many :events

  validates   :name,
              presence: true

  validates   :address,
              presence: true,
              json: {
                schema: -> { address_schema },
                message: ->(errors) { errors }
              }

  def address_schema
    {
      type: 'object',
      required: %w(street city state zip),
      additionalProperties: false,
      properties: {
        street: { type: 'string', maxLength: 50 },
        street2: { type: 'string', maxLength: 50 },
        city: { type: 'string', maxLength: 100 },
        state: { type: 'string', enum: state_codes },
        zip: {
          type: 'string',
          anyOf: [
            { pattern: "^\\d{5}$" },
            { pattern: "^\\d{5}-\\d{4}$" }
          ]
        }
      }
    }.to_json
  end

  def state_codes
    %w(AL AK AS AZ AR AA AE AP CA CO CT DE DC FM FL GA GU HI ID IL IN IA KS KY LA ME MH MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND MP OH OK OR PW PA PR RI SC SD TN TX UT VT VI VA WA WV WI WY)
  end
end
