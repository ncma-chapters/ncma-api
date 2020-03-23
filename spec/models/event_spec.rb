require 'rails_helper'

RSpec.describe Event, :type => :model do
  describe '#deleted?' do
    it 'returns true if deleted_at is set' do
      expect(subject.deleted?).to eq(false)

      subject.deleted_at = DateTime.now
      expect(subject.deleted?).to eq(true)
    end
  end

  describe '#canceled?' do
    it 'returns true if canceled_at is set' do
      expect(subject.canceled?).to eq(false)

      subject.canceled_at = DateTime.now
      expect(subject.canceled?).to eq(true)
    end
  end

  describe '#upcoming?' do
    it 'returns false if starting_at is not set' do
      expect(subject.upcoming?).to eq(false)
    end

    it 'returns true if starting_at greater than now' do
      expect(subject.upcoming?).to eq(false)

      subject.starting_at = DateTime.now + 1.day
      expect(subject.upcoming?).to eq(true)
    end

    it 'returns false if starting_at is less than now' do
      expect(subject.upcoming?).to eq(false)

      subject.starting_at = DateTime.now - 1.day
      expect(subject.upcoming?).to eq(false)
    end
  end

  describe '#published?' do
    it 'returns false if published_at is not set' do
      expect(subject.published?).to eq(false)
    end

    it 'returns false if deleted_at is set' do
      expect(subject.published?).to eq(false)

      subject.deleted_at = DateTime.now
      expect(subject.published?).to eq(false)
    end

    it 'returns false if published_at greater than now' do
      expect(subject.published?).to eq(false)

      subject.published_at = DateTime.now + 1.day
      expect(subject.published?).to eq(false)
    end

    it 'returns true if published_at is less than or eq to now' do
      expect(subject.published?).to eq(false)

      subject.published_at = DateTime.now - 1.day
      expect(subject.published?).to eq(true)
    end
  end
end
