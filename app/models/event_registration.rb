class EventRegistration < ApplicationRecord
  include EventRegistrationValidations

  validates   :ticket_class, presence: :true
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

  validate :event_is_published, :on => :create
  validate :event_is_upcoming, :on => :create
  validate :event_is_not_canceled, :on => :create
  validate :event_has_capacity, :on => :create
  validate :ticket_class_has_capacity, :on => :create

  # If the ticket class is not free, the EventRegistration should not exist without
  # a corresponding :payment_intent_id
  validates   :payment_intent_id,
              presence: true,
              # ticket_class presence is required above, so we're relying on that
              if: -> { errors.empty? && ticket_class && ticket_class.price != 0 }

  belongs_to :ticket_class
  has_one :event, through: :ticket_class

  def registration_schema
    event.registration_schema
  end

  def create_payment_intent
    raise errors unless only_requires_payment?

    price = ticket_class.price

    self.payment_intent = Stripe::PaymentIntent.create(
      amount: price.cents,
      currency: price.currency.iso_code,
      metadata: {
        'registration.data': JSON(data),
        ticket_class_id: ticket_class_id,
        'First Name': data['firstName'],
        'Last Name': data['lastName'],
        'Email': data['email']
      },
      receipt_email: data['email'],
      statement_descriptor: 'NCMA Events',
      statement_descriptor_suffix: 'NCMA Monmouth'
    )

    self
  end

  def payment_intent=(stripe_payment_intent)
    @payment_intent = stripe_payment_intent
    self.payment_intent_id = stripe_payment_intent.id

    @payment_intent
  end

  def payment_intent
    raise nil if payment_intent_id.nil?
    @payment_intent ||= Stripe::PaymentIntent.retrieve(payment_intent_id)
  end

  def only_requires_payment?
    return false if valid?

    errors.size == 1 &&
      errors[:payment_intent_id] &&
      errors.details[:payment_intent_id][0] &&
      errors.details[:payment_intent_id][0][:error] == :blank
  end
end
