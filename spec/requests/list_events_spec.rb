require 'rails_helper'

RSpec.describe 'Event List', :type => :request do
  let (:headers) { { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' } }

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
      :deleted_published_future_event,
      :published_future_event_with_venue,
      :published_future_event_with_ticket_classes,
    ].each do |key|
      event = create(key)
      @created_events[key] = event
    end
  end

  after(:all) do
    to_delete = { ticket_class_ids: [], event_ids: [], venue_ids: [] }

    @created_events.each do |factory_id, event|
      to_delete[:event_ids].push(event.id)
      to_delete[:venue_ids].push(event.venue.id) if event.venue
      
      if event.ticket_classes.any?
        ids = event.ticket_classes.map(&:id)
        to_delete[:ticket_class_ids].concat(ids)
      end
    end

    [TicketClass, Event, Venue].each do |klcass|
      id_list = to_delete["#{klcass.table_name.singularize}_ids".to_sym]
      klcass.unscoped.where(id: id_list).destroy_all
    end
  end

  describe 'GET /events' do
    it 'returns a list of non-deleted, published events by default' do
      get '/events', headers: headers

      # TODO abstract to: behaves_like 'successful get request'
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/vnd.api+json')

      res_body = JSON(response.body)

      expect(res_body['data']).to be_an_instance_of(Array)
      expect(res_body['data'].count).to eq(4)

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
      expect(event_3['attributes']['venueId']).to eq(expected_event_3.venue.id)
    end

    describe 'when filtering' do

      it 'can list future events' do
        get '/events', headers: headers, params: { filter: { startingAt: 'gte ' + DateTime.now.iso8601 } }

        # TODO abstract to: behaves_like 'successful get request'
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/vnd.api+json')

        res_body = JSON(response.body)

        expect(res_body['data']).to be_an_instance_of(Array)
        expect(res_body['data'].count).to eq(3)

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
          include: 'venue,ticketClasses',
          filter: { startingAt: 'gte ' + DateTime.now.iso8601 }
        }

      res_body = JSON(response.body)

      expect(res_body['data']).to be_an_instance_of(Array)
      expect(res_body['data'].count).to eq(3)

      event_1, event_2 = res_body['data']
      expected_event_1, expected_event_2, expected_event_3 = [
        @created_events[:published_future_event],
        @created_events[:published_future_event_with_venue],
        @created_events[:published_future_event_with_ticket_classes]
      ]

      expect(event_1['id'].to_i).to eq(expected_event_1.id)
      expect(event_1['relationships']['venue']['data']).to eq(nil)
      expect(event_2['id'].to_i).to eq(expected_event_2.id)

      expect(res_body['included'].size).to eq(4)

      venue1, ticketClass1, ticketClass2 = res_body['included'][0], res_body['included'][2], res_body['included'][3]

      expect(venue1['id'].to_i).to eq(expected_event_2.venue.id)
      expect(venue1['attributes']['name']).to eq(expected_event_2.venue.name)
      expect(venue1['attributes']['createdAt']).to be_present
      expect(venue1['attributes']['updatedAt']).to be_present
      expect(venue1['attributes']['ageRestriction']).to eq(nil)
      expect(venue1['attributes']['capacity']).to eq(nil)
      expect(venue1['attributes']['address']).to eq(nil)

      expect(ticketClass1['id'].to_i).to eq(expected_event_3.ticket_classes[0].id)
      expect(ticketClass1['attributes']['name']).to eq(expected_event_3.ticket_classes[0].name)
      expect(ticketClass1['attributes']['createdAt']).to be_present
      expect(ticketClass1['attributes']['updatedAt']).to be_present
      expect(ticketClass1['attributes']['price']['value']).to eq(expected_event_3.ticket_classes[0].price.cents)
      expect(ticketClass1['attributes']['price']['display']).to eq(expected_event_3.ticket_classes[0].price.format)
      expect(ticketClass1['attributes']['price']['currency']).to eq(expected_event_3.ticket_classes[0].price.currency.iso_code)
      expect(ticketClass1['attributes']['minimumQuantity']).to eq(expected_event_3.ticket_classes[0].minimum_quantity)

      expect(ticketClass1['attributes']['maximumQuantity']).to eq(expected_event_3.ticket_classes[0].maximum_quantity)
      expect(ticketClass1['attributes']['sorting']).to eq(expected_event_3.ticket_classes[0].sorting)
      expect(ticketClass1['attributes']['capacity']).to eq(expected_event_3.ticket_classes[0].capacity)
      expect(ticketClass1['attributes']['salesStart']).to eq(expected_event_3.ticket_classes[0].sales_start)
      expect(ticketClass1['attributes']['salesEnd']).to eq(expected_event_3.ticket_classes[0].sales_end)
      expect(ticketClass1['attributes']['orderConfirmationMessage']).to eq(expected_event_3.ticket_classes[0].order_confirmation_message)

      expect(ticketClass2['id'].to_i).to eq(expected_event_3.ticket_classes[1].id)
      expect(ticketClass2['attributes']['name']).to eq(expected_event_3.ticket_classes[1].name)
      expect(ticketClass2['attributes']['createdAt']).to be_present
      expect(ticketClass2['attributes']['updatedAt']).to be_present
      expect(ticketClass2['attributes']['price']['value']).to eq(expected_event_3.ticket_classes[1].price.cents)
      expect(ticketClass2['attributes']['price']['display']).to eq(expected_event_3.ticket_classes[1].price.format)
      expect(ticketClass2['attributes']['price']['currency']).to eq(expected_event_3.ticket_classes[1].price.currency.iso_code)
      expect(ticketClass2['attributes']['minimumQuantity']).to eq(expected_event_3.ticket_classes[1].minimum_quantity)
      expect(ticketClass2['attributes']['maximumQuantity']).to eq(expected_event_3.ticket_classes[1].maximum_quantity)
      expect(ticketClass2['attributes']['sorting']).to eq(expected_event_3.ticket_classes[1].sorting)
      expect(ticketClass2['attributes']['capacity']).to eq(expected_event_3.ticket_classes[1].capacity)
      expect(ticketClass2['attributes']['salesStart']).to eq(expected_event_3.ticket_classes[1].sales_start)
      expect(ticketClass2['attributes']['salesEnd']).to eq(expected_event_3.ticket_classes[1].sales_end)
      expect(ticketClass2['attributes']['orderConfirmationMessage']).to eq(expected_event_3.ticket_classes[1].order_confirmation_message)
    end
  end
end