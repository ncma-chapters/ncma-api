class Event < ApplicationRecord
  scope :published, -> { where.not(published_at: nil) }

  validates :name, presence: true

  belongs_to :venue, optional: true
  has_many :ticket_classes
end
