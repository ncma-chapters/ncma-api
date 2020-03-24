class EventRegistration < ApplicationRecord
  include EventRegistrationValidations

  validate :event_is_published, :on => :create
  validate :event_is_upcoming, :on => :create
  validate :event_is_not_canceled, :on => :create
  validate :event_has_capacity, :on => :create
  validate :ticket_class_has_capacity, :on => :create

  validates   :data,
              presence: true,
              # Fetching the schema requires an event to be attached, which requires a ticket_class to be attached.
              # So this allows those validation to run first, if they pass, then we can get the schema and validate this prop.
              # (note) This record cannot be created without a TicketClass existing and a TicketClass can exist without an Event
              # existing. So it's save to assume that records are not created without this validation running.
              if: -> { event.present? },
              json: {
                schema: -> { registration_schema },
                message: ->(errors) { errors }
              }

  belongs_to :ticket_class
  has_one :event, through: :ticket_class

  def registration_schema
    event.registration_schema
  end
end
