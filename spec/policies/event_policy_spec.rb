require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do

  let(:subject) { described_class.new nil, build(:event) }

  describe 'create?' do
    it 'returns false' do
      expect(subject.create?).to eq(false)
    end
  end
end
