require 'rails_helper'

RSpec.describe 'Authorization:', :type => :request do
  shared_examples_for 'an unauthorized response for' do |resource, actions, factories|
    actions.each do |action|
      http_method, factory = action[:method], action[:factory]
      route = '/' + resource.model_hint.dasherize
      model_name = resource.model_hint

      context "#{model_name}: #{http_method.to_s.upcase} #{route}" do
        before(:all) do
          @model = create(factory) if factory
        end

        after(:all) do
          @model&.destroy
        end

        it 'responds with 403 status' do
          if [:put, :patch].include?(http_method)
            send(http_method, route + "/#{@model.id}", { data: { id: @model.id, type: model_name, attributes: {} } })
            expected_message = "Not authorized to update #{model_name.titleize}"
          elsif http_method === :post
            send(http_method, route, { data: { type: model_name, attributes: {} } })
            expected_message = "Not authorized to create #{model_name.titleize}"
          else
            send(http_method, route, headers: headers)
            expected_message = "?"
          end

          expect(response.status).to eq(403)
          expect(JSON.parse(response.body)).to eq({
            'error' => 'Forbidden',
            'message' => expected_message
          })
        end
      end
    end
  end

  it_behaves_like 'an unauthorized response for', EventResource, [
    { method: :post },
    { method: :put, factory: :published_future_event },
    { method: :patch, factory: :published_future_event },
  ]

  describe 'out of scope requests' do
    context 'for events' do
      before(:all) do
        @model = create(:event)
      end

      after(:all) do
        @model.destroy
      end

      context 'on put' do 
        it 'responds with 404' do
          put "/events/#{@model.id}", { data: { id: @model.id, type: 'events', attributes: { name: 'new name' } } }
          expect(response.status).to eq(404)
        end
      end

      context 'on patch' do 
        it 'responds with 404' do
          patch "/events/#{@model.id}", { data: { id: @model.id, type: 'events', attributes: { name: 'new name' } } }
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
