FactoryBot.define do
  factory :event_registration do
    data { JSON({ firstName: 'Kevin', lastName: 'Mircovich', email: 'kevin@ncmamonmouth.org', title: 'Software Engineer', company: 'NCMA Monmouth' }) }
    ticket_class { nil }

    before(:create) do |event_registration|
      if event_registration&.ticket_class&.price > 0
        event_registration.payment_intent_id = 'pi_' + Faker::Alphanumeric.alpha(number: 24)
      end
    end
  end
end
