class EventRegistrationResource < ApplicationResource 
  class << self
    # There is no way to update event registrations on the API layer
    # but we'll leave this here for good measure
    def updatable_fields(context)
      super - [:payment_intent_id]
    end

    def creatable_fields(context)
      super - [:payment_intent_id]
    end
  end

  has_one :ticket_class
  
  attributes  :data

  after_create :send_email_confirmation

  def send_email_confirmation
    EventRegistrationMailer.with(event_registration: @model).confirmation_email.deliver_now
  end
end
