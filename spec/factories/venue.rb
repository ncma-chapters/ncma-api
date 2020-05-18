FactoryBot.define do
  factory :venue do
    name { 'My Venue' }
    address {{
      street: '1605 W Snow Ave',
      city: 'Tampa',
      state: 'FL',
      zip: '33606'        
    }}
  end
end