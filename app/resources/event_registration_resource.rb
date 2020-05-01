class EventRegistrationResource < ApplicationResource 
  class << self
    # There is no way to update event registrations on the API layer
    # but we'll leave this here for good measuer
    def updatable_fields(context)
      super - [:payment_intent_id]
    end

    def creatable_fields(context)
      super - [:payment_intent_id]
    end
  end

  has_one :ticket_class
  
  attributes  :data
end
