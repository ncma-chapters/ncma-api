require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do

  let(:event) { build(:event) }

  describe 'create?' do
    it 'returns false when user is nil' do
      subject = described_class.new nil, event
      expect(subject.create?).to eq(false)
    end

    it 'returns false when user is not in EventManagers group' do
      user = double
      subject = described_class.new user, event

      expect(user).to receive(:in_group).with(
        'EventManagers'
      ).and_return(
        false
      )

      expect(subject.create?).to eq(false)
    end

    it 'returns true when user is in EventManagers group' do
      user = double
      subject = described_class.new user, event

      expect(user).to receive(:in_group).with(
        'EventManagers'
      ).and_return(
        true
      )

      expect(subject.create?).to eq(true)
    end
  end
end
