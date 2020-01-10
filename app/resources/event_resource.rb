class EventResource < ApplicationResource
  immutable

  attributes :name, :description, :venue_id, :published_at, :starting_at, :ending_at
end