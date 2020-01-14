class VenueResource < ApplicationResource
  attributes :name, :age_restriction, :capacity, :address
  has_many :events
end