require 'rails_helper'

RSpec.describe 'Event List', :type => :request do
  let (:headers) { { 'Content-Type': 'application/vnd.api+json' } }

  before(:all) do
    @created_events = {}

    [
      :unpublished_future_event,
      :unpublished_past_event,
      :published_future_event,
      :published_past_event,
      :deleted_unpublished_past_event,
      :deleted_published_past_event,
      :deleted_unpublished_future_event,
      :deleted_published_future_event
    ].each do |key|
      @created_events[key] = create(key)
    end
  end

  after(:all) do
    ids = @created_events.values.map(&:id)

    # Hard delete all records created by this test suite
    Event.unscoped.where(id: ids).destroy_all
  end

  describe 'GET /events' do
    it 'returns a list of non-deleted, published events' do
      get '/events', headers: headers

      # TODO abstract to: behaves_like 'successful get request'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/vnd.api+json')

      res_body = JSON(response.body)

      expect(res_body['data']).to be_an_instance_of(Array)
      expect(res_body['data'].count).to eq(2)

      event_1, event_2 = res_body['data']

      expected_event_1, expected_event_2 = [
        @created_events[:published_future_event],
        @created_events[:published_past_event]
      ]

      expect(event_1['id']).to be_present
      expect(event_1['type']).to eq('events')
      expect(event_1['attributes']['name']).to eq(expected_event_1.name)
      expect(event_1['attributes']['description']).to eq(expected_event_1.description)
      expect(event_1['attributes']['startingAt']).to eq(expected_event_1.starting_at.iso8601(3))
      expect(event_1['attributes']['endingAt']).to eq(expected_event_1.ending_at.iso8601(3))
      expect(event_1['attributes']['publishedAt']).to eq(expected_event_1.published_at.iso8601(3))
      expect(event_1['attributes']['deletedAt']).to eq(nil)
      expect(event_1['attributes']['venueId']).to eq(nil)
      # # TODO: computed properties
      # expect(event_1.start).to eq({ })
      # expect(event_1.end).to eq({ })

      expect(event_2['id']).to be_present
      expect(event_2['type']).to eq('events')
      expect(event_2['attributes']['name']).to eq(expected_event_2.name)
      expect(event_2['attributes']['description']).to eq(expected_event_2.description)
      expect(event_2['attributes']['startingAt']).to eq(expected_event_2.starting_at.iso8601(3))
      expect(event_2['attributes']['endingAt']).to eq(expected_event_2.ending_at.iso8601(3))
      expect(event_2['attributes']['publishedAt']).to eq(expected_event_2.published_at.iso8601(3))
      expect(event_2['attributes']['deletedAt']).to eq(nil)
      expect(event_2['attributes']['venueId']).to eq(nil)
      # # TODO: computed properties
      # expect(event_2.start).to eq({ })
      # expect(event_2.end).to eq({ })
    end

    xit 'can filter list to only future events' do
      # TODO abstract to: behaves_like 'successful get request'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/vnd.api+json')

      res_body = JSON(response.body)

      expect(res_body['data']).to be_an_instance_of(Array)
      expect(res_body['data'].count).to eq(1)
    end

    xit 'can include the venue' do

    end
  end
end