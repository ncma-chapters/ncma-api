require 'rails_helper'

RSpec.describe 'TicketClasses (as EventManager)', :type => :request do
  describe 'POST /ticket-classes' do
    before(:all) do
      @event = create(:event)
    end

    after(:all) do
      @event.destroy
    end

    it 'POST /ticket-classes' do
      new_ticket_class_payload = {
        'data' => {
          'type' => 'ticketClasses',
          'attributes' => {
            "name" => "GA",
            "description" => "For Everyone",
            "price" => {
              "value" => 10_00
            },
            "eventId" => @event.id
          }
        }
      }

      expected_attributes = new_ticket_class_payload['data']['attributes']

      post_as :event_manager, '/ticket-classes', new_ticket_class_payload

      expect(response.status).to eq(201)

      res_body = JSON.parse(response.body)

      expect(res_body['data']['id']).to be_present
      expect(res_body['data']['type']).to eq 'ticketClasses'
      expect(res_body['data']['attributes']).to be_present
      expect(res_body['data']['attributes']['createdAt']).to be_present
      expect(res_body['data']['attributes']['updatedAt']).to be_present
      expect(res_body['data']['attributes']['name']).to eq(expected_attributes['name'])
      expect(res_body['data']['attributes']['description']).to eq(expected_attributes['description'])
      expect(res_body['data']['attributes']['sorting']).to eq(expected_attributes['sorting'])
      expect(res_body['data']['attributes']['capacity']).to eq(expected_attributes['capacity'])
      expect(res_body['data']['attributes']['salesStart']).to eq(expected_attributes['salesStart'])
      expect(res_body['data']['attributes']['salesEnd']).to eq(expected_attributes['salesEnd'])
      expect(res_body['data']['attributes']['orderConfirmationMessage']).to eq(expected_attributes['orderConfirmationMessage'])
      expect(res_body['data']['attributes']['eventId']).to eq(expected_attributes['eventId'])
      expect(res_body['data']['attributes']['price']).to be_present
      expect(res_body['data']['attributes']['price']['value']).to eq(expected_attributes['price']['value'])
      expect(res_body['data']['attributes']['price']['display']).to eq('$10.00')
      expect(res_body['data']['attributes']['price']['currency']).to eq('USD')
    end
  end

  describe 'PUT /ticket-classes' do
    before(:all) do
      @ticketClass = create(:ticket_class)
    end

    after(:all) do
      @ticketClass.destroy
    end

    it 'can PUT an event' do
      ticket_class_payload = {
        'data' => {
          'type' => 'ticketClasses',
          'id' => @ticketClass.id,
          'attributes' => {
            "name" => "NOT GA",
            "description" => "NOT For Everyone",
            "price" => {
              "value" => 1_000_00
            },
            "eventId" => @ticketClass.event_id
          }
        }
      }

      expected_attributes = ticket_class_payload['data']['attributes']

      put_as :event_manager, "/ticket-classes/#{@ticketClass.id}", ticket_class_payload

      expect(response.status).to eq(200)

      res_body = JSON.parse(response.body)

      expect(res_body['data']['id']).to be_present
      expect(res_body['data']['type']).to eq 'ticketClasses'
      expect(res_body['data']['attributes']).to be_present
      expect(res_body['data']['attributes']['createdAt']).to be_present
      expect(res_body['data']['attributes']['updatedAt']).to be_present
      expect(res_body['data']['attributes']['name']).to eq(expected_attributes['name'])
      expect(res_body['data']['attributes']['description']).to eq(expected_attributes['description'])
      expect(res_body['data']['attributes']['sorting']).to eq(expected_attributes['sorting'])
      expect(res_body['data']['attributes']['capacity']).to eq(expected_attributes['capacity'])
      expect(res_body['data']['attributes']['salesStart']).to eq(expected_attributes['salesStart'])
      expect(res_body['data']['attributes']['salesEnd']).to eq(expected_attributes['salesEnd'])
      expect(res_body['data']['attributes']['orderConfirmationMessage']).to eq(expected_attributes['orderConfirmationMessage'])
      expect(res_body['data']['attributes']['eventId']).to eq(expected_attributes['eventId'])
      expect(res_body['data']['attributes']['price']).to be_present
      expect(res_body['data']['attributes']['price']['value']).to eq(expected_attributes['price']['value'])
      expect(res_body['data']['attributes']['price']['display']).to eq('$1,000.00')
      expect(res_body['data']['attributes']['price']['currency']).to eq('USD')
    end
  end

  describe 'PATCH /ticket-classes' do
    before(:all) do
      @ticketClass = create(:ticket_class)
    end

    after(:all) do
      @ticketClass.destroy
    end

    it 'can PATCH an event' do
      new_venue_payload = {
        'data' => {
          'type' => 'ticketClasses',
          'id' => @ticketClass.id,
          'attributes' => {
            "name" => "NOT GA",
            "description" => "NOT For Everyone",
            "price" => {
              "value" => 1_000_00
            },
            "eventId" => @ticketClass.event_id
          }
        }
      }

      expected_attributes = new_venue_payload['data']['attributes']

      patch_as :event_manager, "/ticket-classes/#{@ticketClass.id}", new_venue_payload

      expect(response.status).to eq(200)

      res_body = JSON.parse(response.body)

      expect(res_body['data']['id']).to be_present
      expect(res_body['data']['type']).to eq 'ticketClasses'
      expect(res_body['data']['attributes']).to be_present
      expect(res_body['data']['attributes']['createdAt']).to be_present
      expect(res_body['data']['attributes']['updatedAt']).to be_present
      expect(res_body['data']['attributes']['name']).to eq(expected_attributes['name'])
      expect(res_body['data']['attributes']['description']).to eq(expected_attributes['description'])
      expect(res_body['data']['attributes']['sorting']).to eq(expected_attributes['sorting'])
      expect(res_body['data']['attributes']['capacity']).to eq(expected_attributes['capacity'])
      expect(res_body['data']['attributes']['salesStart']).to eq(expected_attributes['salesStart'])
      expect(res_body['data']['attributes']['salesEnd']).to eq(expected_attributes['salesEnd'])
      expect(res_body['data']['attributes']['orderConfirmationMessage']).to eq(expected_attributes['orderConfirmationMessage'])
      expect(res_body['data']['attributes']['eventId']).to eq(expected_attributes['eventId'])
      expect(res_body['data']['attributes']['price']).to be_present
      expect(res_body['data']['attributes']['price']['value']).to eq(expected_attributes['price']['value'])
      expect(res_body['data']['attributes']['price']['display']).to eq('$1,000.00')
      expect(res_body['data']['attributes']['price']['currency']).to eq('USD')
    end
  end
end
