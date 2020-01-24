class TicketClass < ApplicationRecord
  monetize :cost_cents

  belongs_to :event
end
