FactoryBot.define do
  factory :event_registration do
    data { JSON({ firstName: 'Kevin', lastName: 'Mircovich', email: 'kevin@ncmamonmouth.org', title: 'Software Engineer', company: 'NCMA Monmouth' }) }
    ticket_class { nil }
  end
end
