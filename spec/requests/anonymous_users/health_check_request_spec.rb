require 'rails_helper'

RSpec.describe 'Health Check', :type => :request do
  it 'responds' do
    get '/health'

    expect(response.status).to eq(200)
    expect(response.body).to eq({ status: 'ok' }.to_json)
  end
end