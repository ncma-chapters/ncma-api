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

  it 'can complete the registration' do
    headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      'HTTP_STRIPE_SIGNATURE': '__MY_STRIPE_SIGNATURE'
    }

    request_body = { data: '__REQUEST_BODY' }

    payment_intent = double(
      'Stripe::PaymentIntent',
      id: 'pi_1234567890',
      metadata: {
        'registration.data' => {
          firstName: 'Kevin',
          lastName: 'Mircovich',
          email: 'kevin@ncmamonmouth.org',
          company: 'NCMA Monmouth',
          title: 'Organizer'
        },
        'ticket_class_id' => @ticket_class.id,
        'First Name' => 'Kevin',
        'Last Name' => 'Mircovich',
        'Email' => 'kevin@ncmamonmouth.org',
      }
    )

    event = double(
      type: 'payment_intent.succeeded',
      data: double(
        object: payment_intent
      )
    )

    stub_const("HooksController::STRIPE_WEBHOOK_SIGNING_SECRET", '__MY_STRIPE_WEBHOOK_SECRET')

    expect(Stripe::Webhook).to receive(:construct_event).with(
      JSON(request_body),
      '__MY_STRIPE_SIGNATURE',
      '__MY_STRIPE_WEBHOOK_SECRET'
    ).and_return(event)

    event_registration_mailer = double
    confirmation_email = double

    expect(confirmation_email).to receive(:deliver_now)

    expect(EventRegistrationMailer).to receive(:with).with(
      event_registration: instance_of(EventRegistration)
    ).and_return(
      event_registration_mailer
    )

    expect(event_registration_mailer).to receive(:confirmation_email).and_return(confirmation_email)

    post '/hooks/stripe', request_body, headers

    expect(response.status).to eq(201)

    res_body = JSON(response.body)

    expect(res_body['data']).to be_present
    expect(res_body['data']['created_at']).to be_present
    expect(res_body['data']['updated_at']).to be_present
    expect(res_body['data']['ticket_class_id']).to eq @ticket_class.id
    expect(res_body['data']['payment_intent_id']).to eq 'pi_1234567890'
    expect(res_body['data']['data']['firstName']).to eq 'Kevin'
    expect(res_body['data']['data']['lastName']).to eq 'Mircovich'
    expect(res_body['data']['data']['email']).to eq 'kevin@ncmamonmouth.org'
    expect(res_body['data']['data']['title']).to eq 'Organizer'
    expect(res_body['data']['data']['company']).to eq 'NCMA Monmouth'
  end
end
