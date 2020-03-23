class Event < ApplicationRecord
  scope :published, -> { where.not(published_at: nil) }

  validates :name, presence: true

  belongs_to :venue, optional: true
  has_many :ticket_classes
  has_many :event_registrations, through: :ticket_classes

  def registration_schema
    {
      type: 'object',
      required: %w[firstName lastName email],
      additionalProperties: false,
      properties: {
        firstName: { type: 'string' },
        lastName: { type: 'string' },
        email: { type: 'string' },
        title: { type: 'string' },
        company: { type: 'string' },
      }
    }.to_json
  end

  def deleted?
    !!deleted_at
  end

  def published?
    !deleted? && !!published_at && published_at <= DateTime.now
  end

  def upcoming?
    !!starting_at && starting_at > DateTime.now
  end
end
