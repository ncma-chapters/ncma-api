class TicketClassResource < ApplicationResource  
  has_one   :event
  has_many  :event_registrations
  
  attributes  :name,
              :description,
              :sorting,
              :capacity,
              :sales_start,
              :sales_end,
              :order_confirmation_message,
              :event_id

  attribute :price, format: :currency
end