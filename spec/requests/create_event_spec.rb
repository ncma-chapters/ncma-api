require 'rails_helper'

RSpec.describe 'Create Event', :type => :request do
  before(:all) do
    @venue = create(:venue)

    @new_event_payload = {
      'data' => {
        'type' => 'events',
        'attributes' => {
          'name' => 'Developing Winning Proposals',
          'description' => 'Developing Winning Proposals is designed to provide you with the nuts and bolts you need to review a request for proposal (RFP).',
          'publishedAt' => (DateTime.now).iso8601,
          'startingAt' => (DateTime.now + 2.weeks).iso8601,
          'endingAt' => (DateTime.now + 2.weeks + 2.hours).iso8601,
          'venueId' => @venue.id
        }
      }
    }
  end

  after(:all) do
    @venue.destroy
  end

  it 'can create an event' do
    expected_attributes = @new_event_payload['data']['attributes']

    post_as :event_manager, '/events', @new_event_payload

    expect(response.status).to eq(201)

    binding.pry

    res_body = JSON.parse(response.body)

    expect(res_body['data']['id']).to be_present
    expect(res_body['data']['type']).to eq 'events'
    expect(res_body['data']['attributes']).to be_present
    expect(res_body['data']['attributes']['createdAt']).to be_present
    expect(res_body['data']['attributes']['updatedAt']).to be_present
    expect(res_body['data']['attributes']['name']).to eq expected_attributes['name']
    expect(res_body['data']['attributes']['description']).to eq expected_attributes['description']
    expect(res_body['data']['attributes']['venueId']).to eq expected_attributes['venueId']
    expect(res_body['data']['attributes']['publishedAt']).to eq expected_attributes['publishedAt'].to_datetime.utc.iso8601(3)
    expect(res_body['data']['attributes']['startingAt']).to eq expected_attributes['startingAt'].to_datetime.utc.iso8601(3)
    expect(res_body['data']['attributes']['endingAt']).to eq expected_attributes['endingAt'].to_datetime.utc.iso8601(3)
  end
end
