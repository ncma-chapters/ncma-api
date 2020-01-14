class EventResource < ApplicationResource
  immutable

  attributes :name, :description, :venue_id, :published_at, :starting_at, :ending_at
  filter :starting_at, apply: comparison_filter_for(:starting_at)
  has_one :venue

  # https://github.com/cerebris/jsonapi-resources-site/blob/master/src/v0.9/guide/resources.md#customizing-base-records-for-finder-methods
  def self.records(options = {})
    # Unauthenticated users can only view undeleted, published events.
    # TODO: check user's authorization to change what events are provided (i.e. unpublished events)
    Event.published
  end
end