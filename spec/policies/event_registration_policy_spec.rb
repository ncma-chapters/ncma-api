require 'rails_helper'

RSpec.describe EventRegistrationPolicy, type: :policy do

  subject { described_class.new nil, build(:event_registration) }

  describe 'create?' do
    it 'returns true' do
      expect(subject.create?).to eq(true)
    end
  end
end
