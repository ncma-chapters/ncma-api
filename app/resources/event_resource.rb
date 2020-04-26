class EventResource < ApplicationResource
  has_one :venue # has_one for JSONAPI::Resources and belongs_to for ActiveRecord
  has_many :ticket_classes

  attributes :name, :description, :venue_id, :published_at, :starting_at, :ending_at, :capacity

  filter :starting_at, apply: comparison_filter_for(:starting_at)

  # https://github.com/cerebris/jsonapi-resources-site/blob/master/src/v0.9/guide/resources.md#customizing-base-records-for-finder-methods
  def self.records(options = {})
    if options[:context]&.user&.in_group('EventManagers')
      Event.all
    else
      Event.published
    end
  end
end
