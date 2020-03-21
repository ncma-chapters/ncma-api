class TicketClassResource < ApplicationResource
  immutable
  
  has_one   :event
  has_many  :event_registrations
  
  attributes  :name,
              :description,
              :minimum_quantity,
              :maximum_quantity,
              :sorting,
              :capacity,
              :sales_start,
              :sales_end,
              :order_confirmation_message,
              :price,
              :event_id

  def price
    {
      currency: @model.price.currency.iso_code,
      value: @model.price.fractional,
      display: @model.price.format,
    }
  end
end