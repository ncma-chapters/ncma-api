require 'rails_helper'

RSpec.describe TicketClass, :type => :model do
  describe '#remaining_capacity' do

    context 'when capacity is nil' do
      it 'defaults to event.remaining_capacity' do
        expect(subject.remaining_capacity).to eq(nil) # no event is attached

        event = create(:event)
        subject.event = event

        expect(subject.remaining_capacity).to eq(200)
        expect(subject.remaining_capacity).to eq(event.remaining_capacity)
      end
    end

    context 'when capacity is defined' do
      it 'returns the capacity less all it\'s registrations' do
        event = create(:published_future_event)

        subject.name = 'General Entry'
        subject.price = 0
        subject.event_id = event.id
        subject.capacity = 8

        subject.save!

        # Create 4 registrations (2 for the ticket class)
        create(:event_registration, ticket_class_id: subject.id)
        create(:event_registration, ticket_class_id: subject.id)
        create(:event_registration, ticket_class_id: subject.id)
        create(:event_registration, ticket_class_id: subject.id)

        expect(subject.remaining_capacity).to eq(4)
      end

      it "will be the event's remaining capacity if the event's remaining capacity is less than the ticket class's capacity" do
        event = create(:published_future_event, capacity: 4)

        subject.name = 'General Entry'
        subject.price = 0
        subject.event_id = event.id
        subject.capacity = 8

        subject.save!

        # Create 4 registrations (2 for the ticket class)
        create(:event_registration, ticket_class_id: subject.id)
        create(:event_registration, ticket_class_id: subject.id)

        expect(subject.remaining_capacity).to eq(2)
      end
    end
  end
end
