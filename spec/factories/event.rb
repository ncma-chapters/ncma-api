FactoryBot.define do
  factory :event do
    name { 'My Event' }

    # TODO: can I set created_at time stamps??
    # creates_at= shouldn't be public, but I kinda need to set it for items created some time ago.

    # TODO: refactor to use traits
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#traits
    factory :unpublished_future_event do
      starting_at { DateTime.now + 10.days }
      ending_at { DateTime.now + 10.days + 2.hours }
    end

    factory :unpublished_past_event do
      starting_at { DateTime.now - 10.days }
      ending_at { DateTime.now - 10.days + 2.hours }
    end

    factory :published_future_event do
      published_at { DateTime.now - 5.days } # published 5 days ago
      starting_at { DateTime.now + 10.days } # events is 10 days away
      ending_at { DateTime.now + 10.days + 2.hours }
    end

    factory :published_past_event do
      published_at { DateTime.now - 15.days }
      starting_at { DateTime.now - 10.days }
      ending_at { DateTime.now - 10.days + 2.hours }
    end

    factory :deleted_unpublished_past_event do
      deleted_at { DateTime.now - 15.days }
      starting_at { DateTime.now - 10.days }
      ending_at { DateTime.now - 10.days + 2.hours }
    end

    factory :deleted_published_past_event do
      published_at { DateTime.now - 20.days }
      deleted_at { DateTime.now - 15.days }
      starting_at { DateTime.now - 10.days }
      ending_at { DateTime.now - 10.days + 2.hours }
    end

    factory :deleted_unpublished_future_event do
      deleted_at { DateTime.now - 5.days }
      starting_at { DateTime.now + 10.days }
      ending_at { DateTime.now + 10.days + 2.hours }
    end

    factory :deleted_published_future_event do
      published_at { DateTime.now - 20.days }
      deleted_at { DateTime.now - 15.days }
      starting_at { DateTime.now + 10.days }
      ending_at { DateTime.now + 10.days + 2.hours }
    end

    factory :published_future_event_with_venue do
      published_at { DateTime.now - 2.days }
      starting_at { DateTime.now + 14.days }
      ending_at { DateTime.now + 14.days + 8.hours }

      venue
    end

    factory :published_future_event_with_ticket_classes do
      published_at { DateTime.now - 3.days }
      starting_at { DateTime.now + 6.days }
      ending_at { DateTime.now + 6.days + 1.5.hours }

      venue

      after(:create) do |event, evaluator|
        create  :ticket_class, event: event, maximum_quantity: 5, sorting: 1, capacity: 10
        create  :ticket_class, name: 'Premium', event: event, maximum_quantity: 5, sorting: 2, capacity: 10
      end
    end
  end
end
