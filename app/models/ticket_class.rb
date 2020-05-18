class TicketClass < ApplicationRecord
  monetize :price_cents

  belongs_to :event
  has_many :event_registrations

  validates :name, presence: true

  def remaining_capacity
    return nil if !event
    return event.remaining_capacity if capacity.blank?

    self_remaining_capacity = capacity - event_registrations.size
    event.remaining_capacity < self_remaining_capacity ? event.remaining_capacity : self_remaining_capacity
  end
end
