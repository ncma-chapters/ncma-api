require 'rails_helper'

RSpec.describe 'List Event Registrations', :type => :request do
  before(:all) do
    @event = create(:published_future_event_with_ticket_classes)

    @ticket_classes = @event.ticket_classes

    @event_registrations = [
      { firstName: 'Kevin', lastName: 'Mircovich', email: 'kevin@ncmamonmuth.org' },
      { firstName: 'Kelson', lastName: 'Adams', email: 'kevin@ncmamonmuth.org', title: 'Engineer' },
      { firstName: 'Arthur', lastName: 'Green', email: 'arthur@ncmamonmuth.org', company: 'NCMA Monmouth', title: 'Designer' },
      { firstName: 'Patrick', lastName: 'Sanders', email: 'patrick@ncmamonmuth.org', company: 'NCMA Monmouth' }
    ].map.with_index do |data, index|
      ticket_class_id = @ticket_classes[index % 2].id
      create(:event_registration, data: data, ticket_class_id: ticket_class_id)
    end
  end

  after(:all) do
    @event_registrations.each(&:destroy!)
    @ticket_classes.each(&:destroy!)
    @event.destroy!
  end

  it 'can list attedees' do
    get "/events/#{@event.id}/event-registrations?include=ticketClass"

    expect(response.status).to eq 200

    res_body = JSON.parse response.body

    res_body.each_with_index do |res_item, index|
      received = res_body['data'][index]
      expected = @event_registrations[index]

      expect(received['id']).to eq(expected['id'].to_s)
      expect(received['type']).to eq('eventRegistrations')
      expect(received['attributes']).to be_present
      expect(received['attributes']['data']).to eq(expected['data'])
      expect(received['attributes']['createdAt']).to be_present
      expect(received['attributes']['updatedAt']).to be_present
      expect(received['relationships']['ticketClass']['data']['type']).to eq "ticketClasses"
      expect(received['relationships']['ticketClass']['data']['id']).to eq expected.ticket_class_id.to_s
    end

    expect(res_body['included'].size).to eq(2)

    res_body['included'].each_with_index do |included, index|
      received = res_body['included'][index]
      expected = @ticket_classes[index]

      expect(received['id']).to eq expected.id.to_s
      expect(received['type']).to eq 'ticketClasses'
      expect(received['attributes']).to be_present
      expect(received['attributes']['createdAt']).to be_present
      expect(received['attributes']['updatedAt']).to be_present
      expect(received['attributes']['eventId']).to eq @event.id
      expect(received['attributes']['price']['currency']).to eq expected.price.currency.iso_code
      expect(received['attributes']['price']['display']).to eq expected.price.format
      expect(received['attributes']['price']['value']).to eq expected.price.cents
    end
  end
end
