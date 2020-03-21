require 'rails_helper'

RSpec.describe 'Free Event Registration', :type => :request do
  let (:headers) { { Accept: 'application/vnd.api+json', 'Content-Type': 'application/vnd.api+json' } }

  before do
    @event = create(:published_future_event_with_venue, name: 'AMA Webinar')
    @ticket_class = create(:ticket_class, event_id: @event.id, price: 0, name: 'General Registration')
  end

  after do
    # @ticket_class.destroy
    # @event.venue.destroy
    # @event.destroy
  end

  it 'allows anyone to register without payment' do
    request_body = {
      data: {
        type: 'eventRegistrations',
        attributes: {
          data: JSON(build(:event_registration).data)
        },
        relationships: {
          ticketClass: {
            data: {
              type: 'ticketClasses',
              id: @ticket_class.id
            }
          }
        }
      }
    }

    # post "/events/#{@event.id}/ticket-classes/#{@ticket_class.id}/event-registrations", params: request_body, headers: headers, as: :json
    post "/event-registrations", params: request_body, headers: headers, as: :json

    expect(response.status).to eq(201)

    res_body = JSON(response.body)

    expect(res_body['data']['id']).to be_present
    expect(res_body['data']['type']).to eq 'eventRegistrations'
    expect(res_body['data']['attributes']).to be_present
    expect(res_body['data']['attributes']['createdAt']).to be_present
    expect(res_body['data']['attributes']['updatedAt']).to be_present
    expect(res_body['data']['attributes']['data']['firstName']).to eq 'Kevin'
    expect(res_body['data']['attributes']['data']['lastName']).to eq 'Mircovich'
    expect(res_body['data']['attributes']['data']['email']).to eq 'kevin@ncmamonmouth.org'
    expect(res_body['data']['attributes']['data']['title']).to eq 'Software Engineer'
    expect(res_body['data']['attributes']['data']['company']).to eq 'NCMA Monmouth'
  end
end
