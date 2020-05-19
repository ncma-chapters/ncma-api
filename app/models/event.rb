class Event < ApplicationRecord
  scope :published, -> { where.not(published_at: nil) }

  validates :name, presence: true
  validates :starting_at, presence: true, if: -> { published? }
  validates :ending_at, presence: true, if: -> { published? }

  belongs_to :venue, optional: true
  has_many :ticket_classes
  has_many :event_registrations, through: :ticket_classes

  def remaining_capacity
    capacity - event_registrations.size
  end

  def registration_schema
    {
      type: 'object',
      required: %w(firstName lastName email),
      additionalProperties: false,
      properties: {
        firstName: { type: 'string', maxLength: 50 },
        lastName: { type: 'string', maxLength: 50 },
        email: {
          type: 'string',
          maxLength: 100,
          pattern: '^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$',
        },
        title: { type: 'string', maxLength: 100 },
        company: { type: 'string', maxLength: 100 },
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

  def canceled?
    !!canceled_at
  end

  def single_day_event?(timezone = 'US/Eastern')
    starting_at&.in_time_zone(timezone).to_date == ending_at.in_time_zone(timezone)&.to_date
  end
end
