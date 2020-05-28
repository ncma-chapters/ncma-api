require 'rails_helper'

RSpec.describe HooksController, type: :controller do
  it 'inherits from applciation controller' do
    expect(described_class.ancestors).not_to include(ApplicationController)
    expect(described_class.ancestors).to include(ActionController::API)
  end

  it "sets STRIPE_WEBHOOK_SIGNING_SECRET to ENV['STRIPE_WEBHOOK_SIGNING_SECRET']" do
    expect(described_class::STRIPE_WEBHOOK_SIGNING_SECRET).to eq(ENV['STRIPE_WEBHOOK_SIGNING_SECRET'])
  end
end
