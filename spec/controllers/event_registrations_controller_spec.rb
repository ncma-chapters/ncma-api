require 'rails_helper'

RSpec.describe EventRegistrationsController, :type => :controller do
  it 'inherits from applciation controller' do
    expect(described_class.ancestors).to include(ApplicationController)
  end
end
