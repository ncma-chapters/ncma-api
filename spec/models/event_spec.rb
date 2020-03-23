require 'rails_helper'

RSpec.describe Event, :type => :model do
  describe 'deleted?' do
    it 'returns true if deleted_at is set' do
      expect(subject.deleted?).to eq(false)

      subject.deleted_at = DateTime.now
      expect(subject.deleted?).to eq(true)
    end
  end

  describe 'published?' do
    it 'returns false if published_at is not set' do
      expect(subject.published?).to eq(false)
    end

    it 'returns false if deleted_at is set' do
      expect(subject.published?).to eq(false)

      subject.deleted_at = DateTime.now
      expect(subject.published?).to eq(false)
    end

    it 'returns false if published_at grater than now' do
      expect(subject.published?).to eq(false)

      subject.published_at = DateTime.now + 1.day
      expect(subject.published?).to eq(false)
    end

    it 'returns true if published_at is less than or eq to DateTime.now' do
      expect(subject.published?).to eq(false)

      subject.published_at = DateTime.now - 1.day
      expect(subject.published?).to eq(true)
    end
  end
end
