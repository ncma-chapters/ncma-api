require 'rails_helper'

RSpec.describe EventPolicy, type: :policy do

  let(:event) { build(:event) }

  shared_examples_for 'it requires user to be in EventManagers group' do |method_name|
    it 'returns false when user is nil' do
      subject = described_class.new nil, event
      expect(subject.send(method_name)).to eq(false)
    end

    it 'returns false when user is not in EventManagers group' do
      user = double
      subject = described_class.new user, event

      expect(user).to receive(:in_group).with(
        'EventManagers'
      ).and_return(
        false
      )

      expect(subject.send(method_name)).to eq(false)
    end

    it 'returns true when user is in EventManagers group' do
      user = double
      subject = described_class.new user, event

      expect(user).to receive(:in_group).with(
        'EventManagers'
      ).and_return(
        true
      )

      expect(subject.send(method_name)).to eq(true)
    end
  end

  describe 'create?' do
    it_behaves_like 'it requires user to be in EventManagers group', :create?
  end

  describe 'update?' do
    it_behaves_like 'it requires user to be in EventManagers group', :update?
  end
end
