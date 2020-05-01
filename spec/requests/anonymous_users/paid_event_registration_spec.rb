require 'rails_helper'

RSpec.describe 'Paid Event Registration', :type => :request do
  run_time = DateTime.now

  before do
    @event = create(:published_future_event_with_venue, name: 'AMA Webinar')
    @ticket_class = create(:ticket_class, event_id: @event.id, price_cents: 1_500_00, name: 'Premium Registration')
  end

  after do
    @ticket_class.event_registrations.destroy_all
    @ticket_class.destroy
    deleted_event = @event.destroy
    deleted_event.venue.destroy
  end

  it 'can start a paid registration', run_at: run_time.iso8601 do
    request_body = {
      data: {
        type: 'eventRegistrations',
        attributes: {
          data: build(:event_registration).data
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

    VCR.use_cassette('stripe/paymeny_intents/post/201') do
      post '/event-registrations', request_body
    end

    expect(response.status).to eq(202)

    res_body = JSON(response.body)

    expect(res_body['data']['id']).to eq(nil)
    expect(res_body['data']['type']).to eq 'eventRegistrations'
    expect(res_body['data']['attributes']).to be_present
    expect(res_body['data']['attributes']['createdAt']).to eq(nil)
    expect(res_body['data']['attributes']['updatedAt']).to eq(nil)
    expect(res_body['data']['attributes']['data']['firstName']).to eq 'Kevin'
    expect(res_body['data']['attributes']['data']['lastName']).to eq 'Mircovich'
    expect(res_body['data']['attributes']['data']['email']).to eq 'kevin@ncmamonmouth.org'
    expect(res_body['data']['attributes']['data']['title']).to eq 'Software Engineer'
    expect(res_body['data']['attributes']['data']['company']).to eq 'NCMA Monmouth'
    expect(res_body['meta']['clientSecret']).to eq('<PAYMENT_INTENT_CLIENT_SECRET>')
    expect(res_body['meta']['paymentIntent']).to be_present
    expect(res_body['meta']['paymentIntent']['id']).to eq('<PAYMENT_INTENT_ID>')
    expect(res_body['meta']['paymentIntent']['object']).to eq('payment_intent')
    expect(res_body['meta']['paymentIntent']['status']).to eq('requires_payment_method')
    expect(res_body['meta']['paymentIntent']['clientSecret']).to eq('<PAYMENT_INTENT_CLIENT_SECRET>')
    expect(res_body['meta']['paymentIntent']['amount']).to eq(1_500_00)
  end
end
