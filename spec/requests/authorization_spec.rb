require 'rails_helper'

RSpec.describe 'Authorization:', :type => :request do
  shared_examples_for 'an unauthorized request to' do |resource, actions|
    actions.each do |action|
      route = '/' + resource.model_hint.dasherize
      model_name = resource.model_hint

      context "#{model_name}: #{action.to_s.upcase} #{route}" do
        it 'responds with 403 status' do
          if [:post, :put, :patch].include?(action)
            send(action, route, { data: { type: model_name, attributes: {} } })
          else
            send(action, route, headers: headers)
          end

          expect(response.status).to eq(403)
          expect(JSON.parse(response.body)).to eq({
            'error' => 'Forbidden',
            'message' => "Not authorized to create #{model_name.titleize}"
          })
        end
      end
    end
  end

  it_behaves_like 'an unauthorized request to', EventResource, [:post]
end
