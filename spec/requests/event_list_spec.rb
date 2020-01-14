require 'rails_helper'

RSpec.describe 'Event List', :type => :request do
  let (:headers) { { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' } }

  before(:all) do
    @created_events = {}
    @created_venue_ids = []

    [
      :unpublished_future_event,
      :unpublished_past_event,
      :published_future_event,
      :published_past_event,
      :deleted_unpublished_past_event,
      :deleted_published_past_event,
      :deleted_unpublished_future_event,
      :deleted_published_future_event,
      :published_future_event_with_venue
    ].each do |key|
      event = create(key)
      @created_events[key] = event

      # :published_future_event_with_venue creates a venue
      @created_venue_ids.push(event.venue_id) if event.venue_id
    end
  end

  after(:all) do
    ids = @created_events.values.map(&:id)

    # Hard delete all records created by this test suite
    Event.unscoped.where(id: ids).destroy_all
    Venue.unscoped.where(id: @created_venue_ids).destroy_all
  end

  describe 'GET /events' do
    it 'returns a list of non-deleted, published events by default' do
      get '/events', headers: headers

      # TODO abstract to: behaves_like 'successful get request'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/vnd.api+json')

      res_body = JSON(response.body)

      expect(res_body['data']).to be_an_instance_of(Array)
      expect(res_body['data'].count).to eq(3)

      event_1, event_2, event_3 = res_body['data']

      expected_event_1, expected_event_2, expected_event_3 = [
        @created_events[:published_future_event],
        @created_events[:published_past_event],
        @created_events[:published_future_event_with_venue]
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

      expect(event_2['id']).to be_present
      expect(event_2['type']).to eq('events')
      expect(event_2['attributes']['name']).to eq(expected_event_2.name)
      expect(event_2['attributes']['description']).to eq(expected_event_2.description)
      expect(event_2['attributes']['startingAt']).to eq(expected_event_2.starting_at.iso8601(3))
      expect(event_2['attributes']['endingAt']).to eq(expected_event_2.ending_at.iso8601(3))
      expect(event_2['attributes']['publishedAt']).to eq(expected_event_2.published_at.iso8601(3))
      expect(event_2['attributes']['deletedAt']).to eq(nil)
      expect(event_2['attributes']['venueId']).to eq(nil)

      expect(event_3['id']).to be_present
      expect(event_3['type']).to eq('events')
      expect(event_3['attributes']['name']).to eq(expected_event_3.name)
      expect(event_3['attributes']['description']).to eq(expected_event_3.description)
      expect(event_3['attributes']['startingAt']).to eq(expected_event_3.starting_at.iso8601(3))
      expect(event_3['attributes']['endingAt']).to eq(expected_event_3.ending_at.iso8601(3))
      expect(event_3['attributes']['publishedAt']).to eq(expected_event_3.published_at.iso8601(3))
      expect(event_3['attributes']['deletedAt']).to eq(nil)
      expect(event_3['attributes']['venueId']).to eq(@created_venue_ids[0]) # we only created one venue, so check that one.
    end

    describe 'when filtering' do

      it 'can list future events' do
        get '/events', headers: headers, params: { filter: { startingAt: 'gte ' + DateTime.now.iso8601 } }

        # TODO abstract to: behaves_like 'successful get request'
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/vnd.api+json')

        res_body = JSON(response.body)

        expect(res_body['data']).to be_an_instance_of(Array)
        expect(res_body['data'].count).to eq(2)

        res_data = res_body['data']

        event_1_start, event_2_start = [
          res_data[0]['attributes']['startingAt'],
          res_data[1]['attributes']['startingAt']
        ]

        event_1_expected_start, event_2_expected_start = [
          @created_events[:published_future_event].starting_at.iso8601(3),
          @created_events[:published_future_event_with_venue].starting_at.iso8601(3),
        ]

        expect(event_1_start).to eq(event_1_expected_start)
        expect(event_2_start).to eq(event_2_expected_start)
      end

      xit 'cannot retrieve unpublished' do

      end

      xit 'cannot retrieve deleted events' do

      end
    end

    # TODO: add ticket class to include statement and add resulting expectations
    it 'can include the venue and ticket classes' do
      get '/events',
        headers: headers,
        params: {
          include: 'venue',
          filter: { startingAt: 'gte ' + DateTime.now.iso8601 }
        }

      res_body = JSON(response.body)

      expect(res_body['data']).to be_an_instance_of(Array)
      expect(res_body['data'].count).to eq(2)

      event_1, event_2 = res_body['data']
      expected_event_1, expected_event_2 = [
        @created_events[:published_future_event],
        @created_events[:published_future_event_with_venue]
      ]

      expect(event_1['id'].to_i).to eq(expected_event_1.id)
      expect(event_1['relationships']['venue']['data']).to eq(nil)
      expect(event_2['id'].to_i).to eq(expected_event_2.id)
      
      included_resources, venue = res_body['included'], res_body['included'][0]

      expect(included_resources.size).to eq(1)

      expect(venue['id'].to_i).to eq(expected_event_2.venue.id)
      expect(venue['attributes']['name']).to eq(expected_event_2.venue.name)
      expect(venue['attributes']['createdAt']).to be_present
      expect(venue['attributes']['updatedAt']).to be_present
      expect(venue['attributes']['ageRestriction']).to eq(nil)
      expect(venue['attributes']['capacity']).to eq(nil)
      expect(venue['attributes']['address']).to eq(nil)
    end
  end
end