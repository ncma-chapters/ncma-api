FactoryBot.define do
  factory :event do
    name { 'My Event' }

    # TODO: can I set created_at time stamps??
    # creates_at= shouldn't be public, but I kinda need to set it for items created some time ago.

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
      ending_at { DateTime.now + 10.days + 2.hours } # events is 10 days away
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
  end
end
