module EventRegistrationValidations
  # There are conditions where an EventRegistration should not be valid based on the state
  # of it's relationships. These are inclided on EventRegistration.
  # 
  # We soft get properties here and rely on the "validates" hooks on the model
  # to ensure that ticekt_class and event are present. If they aren't present
  # we allow the model to have errors from the presense validators.
  def event_is_published
    if event && !event.published?
      errors.add(:base, "Event must be published")
    end
  end

  def event_is_upcoming
    if event && !event.upcoming?
      errors.add(:base, "Event must be upcoming")
    end
  end

  def event_is_not_canceled
    if event && event.canceled?
      errors.add(:base, "Event is canceled")
    end
  end

  def event_has_capacity
    if event && event.remaining_capacity <= 0
      errors.add(:base, "Event is at capacity")
    end
  end

  def ticket_class_has_capacity
    if ticket_class && ticket_class.remaining_capacity <= 0
      errors.add(:base, "Ticket Class is at capacity")
    end
  end
end