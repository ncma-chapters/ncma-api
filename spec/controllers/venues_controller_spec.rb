require 'rails_helper'

RSpec.describe VenuesController, :type => :controller do
  it 'inherits from applciation controller' do
    expect(described_class.ancestors).to include(ApplicationController)
  end
end
