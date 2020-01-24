class TicketClassResource < ApplicationResource
  attributes  :name, :description, :minimum_quantity, :maximum_quantity, :sorting,
              :capacity, :sales_start, :sales_end, :order_confirmation_message, :cost

  has_one :events

  def cost
    {
      currency: @model.cost.currency.iso_code,
      value: @model.cost.fractional,
      display: @model.cost.format,
    }
  end
end