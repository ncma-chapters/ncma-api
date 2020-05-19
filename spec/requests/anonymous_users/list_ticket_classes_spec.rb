require 'rails_helper'

RSpec.describe 'List Ticket Classes', :type => :request do
  before(:all) do
    @created_events = {}

    factory_id = :published_future_event_with_ticket_classes
    @created_events[factory_id] = create(factory_id) # Create an event with a couple ticket classes
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

  describe 'Listing Ticket Classes' do
    it 'can list ticket classes for a given event' do
      event = @created_events.values[0]
      
      get "/events/#{event.id}/ticket-classes"

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/vnd.api+json')

      res_body = JSON(response.body)

      ticketClass1, ticketClass2 = res_body['data'][0], res_body['data'][1]

      expect(ticketClass1['id'].to_i).to eq(event.ticket_classes[0].id)
      expect(ticketClass1['attributes']['name']).to eq(event.ticket_classes[0].name)
      expect(ticketClass1['attributes']['createdAt']).to be_present
      expect(ticketClass1['attributes']['updatedAt']).to be_present
      expect(ticketClass1['attributes']['price']['value']).to eq(event.ticket_classes[0].price.cents)
      expect(ticketClass1['attributes']['price']['display']).to eq(event.ticket_classes[0].price.format)
      expect(ticketClass1['attributes']['price']['currency']).to eq(event.ticket_classes[0].price.currency.iso_code)

      expect(ticketClass1['attributes']['sorting']).to eq(event.ticket_classes[0].sorting)
      expect(ticketClass1['attributes']['capacity']).to eq(event.ticket_classes[0].capacity)
      expect(ticketClass1['attributes']['salesStart']).to eq(event.ticket_classes[0].sales_start)
      expect(ticketClass1['attributes']['salesEnd']).to eq(event.ticket_classes[0].sales_end)

      expect(ticketClass2['id'].to_i).to eq(event.ticket_classes[1].id)
      expect(ticketClass2['attributes']['name']).to eq(event.ticket_classes[1].name)
      expect(ticketClass2['attributes']['createdAt']).to be_present
      expect(ticketClass2['attributes']['updatedAt']).to be_present
      expect(ticketClass2['attributes']['price']['value']).to eq(event.ticket_classes[1].price.cents)
      expect(ticketClass2['attributes']['price']['display']).to eq(event.ticket_classes[1].price.format)
      expect(ticketClass2['attributes']['price']['currency']).to eq(event.ticket_classes[1].price.currency.iso_code)
      expect(ticketClass2['attributes']['sorting']).to eq(event.ticket_classes[1].sorting)
      expect(ticketClass2['attributes']['capacity']).to eq(event.ticket_classes[1].capacity)
      expect(ticketClass2['attributes']['salesStart']).to eq(event.ticket_classes[1].sales_start)
      expect(ticketClass2['attributes']['salesEnd']).to eq(event.ticket_classes[1].sales_end)
    end
  end
end
