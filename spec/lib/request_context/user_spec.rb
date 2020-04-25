require 'rails_helper'

RSpec.describe RequestContext::User, :type => :model do
  describe 'initialize' do
    it 'accepts :original_payload' do
      original_payload = double

      subject = described_class.new original_payload
      expect(subject.original_payload).to eq(original_payload)
    end
  end

  describe '#id' do
    it 'returns the sub from the token' do
      _sub = SecureRandom.uuid

      subject = described_class.new('sub' => _sub)
      expect(subject.id).to eq(_sub)
    end
  end

  describe '#expires_at' do
    it 'returns the payload\'s exp as a DateTime' do
      exp = 1587847206

      subject = described_class.new('exp' => exp)

      expect(subject.expires_at).to eq(
        Time.at(exp).to_datetime
      )
    end
  end

  describe '#issued_at' do
    it 'returns the payload\'s iat as a DateTime' do
      iat = 1587843606

      subject = described_class.new('iat' => iat)

      expect(subject.issued_at).to eq(
        Time.at(iat).to_datetime
      )
    end
  end

  describe '#groups' do
    it 'returns an empty array when payload groups is not present' do
      subject = described_class.new('cognito:groups' => nil)
      expect(subject.groups).to eq([])
    end

    it 'returns array of groups from payload' do
      groups = ['EventManagers', 'ContentManagers']

      subject = described_class.new('cognito:groups' => groups)
      expect(subject.groups).to eq(groups)
    end
  end

  describe '#in_group' do
    it 'checks if the user is in the group provided' do
      groups = ['EventManagers', 'ContentManagers']

      subject = described_class.new('cognito:groups' => groups)
      expect(subject.in_group(groups[0])).to eq(true)
      expect(subject.in_group(groups[1])).to eq(true)
      expect(subject.in_group('OtherGroup')).to eq(false)
    end

    it 'returns boolean when no groups are provided' do
      groups = ['EventManagers', 'ContentManagers']

      subject = described_class.new({})
      expect(subject.in_group(groups[0])).to eq(false)
      expect(subject.in_group(groups[1])).to eq(false)
      expect(subject.in_group('OtherGroup')).to eq(false)
    end
  end
end
