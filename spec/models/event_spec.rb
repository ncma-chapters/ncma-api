require 'rails_helper'

RSpec.describe Event, :type => :model do
  describe '#remaining_capacity' do
    it 'defaults to 200' do
      expect(subject.remaining_capacity).to eq(200)
    end

    it 'returns the capacity less all it\'s registrations' do
      # Save an event
      subject.name = 'My Event'
      subject.starting_at = DateTime.now + 30
      subject.ending_at = DateTime.now + 60
      subject.published_at = DateTime.now - 1

      subject.save!

      # Create 2 ticket classes
      tc_1 = create(:ticket_class, name: 'Basic', price: 0, event_id: subject.id)
      tc_2 = create(:ticket_class, name: 'Plus', price: 0, event_id: subject.id)

      # Create 4 registrations (2 for each ticket class)
      create(:event_registration, ticket_class: tc_1)
      create(:event_registration, ticket_class: tc_1)
      create(:event_registration, ticket_class: tc_2)
      create(:event_registration, ticket_class: tc_2)

      expect(subject.remaining_capacity).to eq(200 - 4)
    end
  end

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
