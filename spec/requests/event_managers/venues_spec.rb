require 'rails_helper'

RSpec.describe 'Venues (as EventManager)', :type => :request do
  describe 'POST /venues' do
    it 'can create an event' do
      new_venue_payload = {
        'data' => {
          'type' => 'venues',
          'attributes' => {
            'name' => 'My Venue',
            'address' => {
              'street' => '123 6th St. N.',
              'city' => 'St. Petersburg',
              'state' => 'FL',
              'zip' => '33701'
            }
          }
        }
      }

      expected_attributes = new_venue_payload['data']['attributes']

      post_as :event_manager, '/venues', new_venue_payload

      expect(response.status).to eq(201)

      res_body = JSON.parse(response.body)

      expect(res_body['data']['id']).to be_present
      expect(res_body['data']['type']).to eq 'venues'
      expect(res_body['data']['attributes']).to be_present
      expect(res_body['data']['attributes']['createdAt']).to be_present
      expect(res_body['data']['attributes']['updatedAt']).to be_present
      expect(res_body['data']['attributes']['name']).to eq expected_attributes['name']
      expect(res_body['data']['attributes']['address']).to eq expected_attributes['address']
      expect(res_body['data']['attributes']['venueId']).to eq expected_attributes['venueId']
    end
  end

  describe 'PUT /venues' do
    before(:all) do
      @venue = create(:venue)
    end

    after(:all) do
      @venue.destroy
    end

    it 'can PUT an event' do
      new_venue_payload = {
        'data' => {
          'type' => 'venues',
          'id' => @venue.id,
          'attributes' => {
            'name' => 'My Venue',
            'address' => {
              'street' => '123 6th St. N.',
              'city' => 'St. Petersburg',
              'state' => 'FL',
              'zip' => '33701'
            }
          }
        }
      }

      expected_attributes = new_venue_payload['data']['attributes']

      put_as :event_manager, "/venues/#{@venue.id}", new_venue_payload

      expect(response.status).to eq(200)

      res_body = JSON.parse(response.body)

      expect(res_body['data']['id']).to be_present
      expect(res_body['data']['type']).to eq 'venues'
      expect(res_body['data']['attributes']).to be_present
      expect(res_body['data']['attributes']['createdAt']).to be_present
      expect(res_body['data']['attributes']['updatedAt']).to be_present
      expect(res_body['data']['attributes']['name']).to eq expected_attributes['name']
      expect(res_body['data']['attributes']['address']).to eq expected_attributes['address']
      expect(res_body['data']['attributes']['venueId']).to eq expected_attributes['venueId']
    end
  end

  describe 'PATCH /venues' do
    before(:all) do
      @venue = create(:venue)
    end

    after(:all) do
      @venue.destroy
    end

    it 'can PATCH an event' do
      new_venue_payload = {
        'data' => {
          'type' => 'venues',
          'id' => @venue.id,
          'attributes' => {
            'name' => 'My Venue',
            'address' => {
              'street' => '123 6th St. N.',
              'city' => 'St. Petersburg',
              'state' => 'FL',
              'zip' => '33701'
            }
          }
        }
      }

      expected_attributes = new_venue_payload['data']['attributes']

      patch_as :event_manager, "/venues/#{@venue.id}", new_venue_payload

      expect(response.status).to eq(200)

      res_body = JSON.parse(response.body)

      expect(res_body['data']['id']).to be_present
      expect(res_body['data']['type']).to eq 'venues'
      expect(res_body['data']['attributes']).to be_present
      expect(res_body['data']['attributes']['createdAt']).to be_present
      expect(res_body['data']['attributes']['updatedAt']).to be_present
      expect(res_body['data']['attributes']['name']).to eq expected_attributes['name']
      expect(res_body['data']['attributes']['address']).to eq expected_attributes['address']
      expect(res_body['data']['attributes']['venueId']).to eq expected_attributes['venueId']
    end
  end
end
