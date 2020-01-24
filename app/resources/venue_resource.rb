class VenueResource < ApplicationResource
  has_many :events
  attributes :name, :age_restriction, :capacity, :address
end