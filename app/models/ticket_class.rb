class TicketClass < ApplicationRecord
  monetize :price_cents

  belongs_to :event
end
