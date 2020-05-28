require 'rails_helper'

RSpec.describe HooksController, type: :controller do
  it 'inherits from applciation controller' do
    expect(described_class.ancestors).not_to include(ApplicationController)
    expect(described_class.ancestors).to include(ActionController::API)
  end
end
