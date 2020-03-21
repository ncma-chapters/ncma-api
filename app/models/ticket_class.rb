class TicketClass < ApplicationRecord
  monetize :price_cents

  belongs_to :event
  has_many :event_registrations
end
