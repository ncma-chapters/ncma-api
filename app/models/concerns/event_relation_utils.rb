module EventRelationUtils
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
end