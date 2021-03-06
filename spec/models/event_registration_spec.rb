require 'rails_helper'

RSpec.describe EventRegistration, :type => :model do
  describe '#data' do
    describe '#event' do
      it 'references the event through the ticket_class relation' do
        event = create(:event)
        subject.ticket_class = create(:ticket_class, event: event)
        
        expect(subject.event).to eq(event)
      end
    end

    describe '#registration_schema' do
      it 'points to the registration_schema on the related event' do
        event = create(:event)
        subject.ticket_class = create(:ticket_class, event: event)

        expect(subject.registration_schema).to eq(subject.event.registration_schema)
        expect(subject.registration_schema).to eq(event.registration_schema)
      end
    end

    describe '#save' do

      describe 'validating #ticket_class' do
        it 'validates the presence of a ticket_class' do
          expect(subject.save).to eq(false)

          expect(subject.errors.messages[:ticket_class][0]).to eq("can't be blank")
          expect(subject.errors.details[:ticket_class][0]).to eq({ :error=>:blank, :with=>:true })
        end

        it 'validates the capacity of the ticket_class' do
          data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com' }
          event = create(:published_future_event)
          tc = create(:ticket_class, capacity: 2, event_id: event.id)

          subject.ticket_class_id = tc.id
          subject.data = data

          # Insert registrations to reach the tc's capacity
          create(:event_registration, ticket_class_id: tc.id)
          create(:event_registration, ticket_class_id: tc.id)

          result = subject.save

          expect(result).to eq(false)
          expect(subject.errors.messages[:base]).to include("Ticket Class is at capacity")
        end
      end

      describe 'validating #event' do
        it 'validates that the event is upcoming' do
          subject.ticket_class = create(:ticket_class, event: create(:published_past_event))

          result = subject.save

          expect(result).to eq(false)
          expect(subject.errors.messages[:base]).to eq(['Event must be upcoming'])
        end

        it 'validates that the event is published' do
          event = create(:event)
          subject.ticket_class = create(:ticket_class, event: create(:unpublished_future_event))

          result = subject.save

          expect(result).to eq(false)
          expect(subject.errors.messages[:base]).to eq(['Event must be published'])
        end

        it 'validates the capacity of the event' do
          data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com' }
          event = create(:published_future_event, capacity: 2)
          tc = create(:ticket_class, capacity: 3, event_id: event.id)

          subject.ticket_class_id = tc.id
          subject.data = data

          # Insert registrations to reach the event's capacity
          create(:event_registration, ticket_class_id: tc.id)
          create(:event_registration, ticket_class_id: tc.id)

          result = subject.save

          expect(result).to eq(false)
          expect(subject.errors.messages[:base]).to include("Event is at capacity")
        end
      end

      describe 'validating #data' do
        it 'validates #data against its event\'s registration_schema when after properties are valid' do
          data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com' }

          subject.ticket_class = create(:ticket_class, event: create(:published_future_event))
          subject.data = data

          expect(subject).to receive(:payment_intent_id).and_return('pi_q23e')

          result = subject.save

          expect(result).to eq(true)
          expect(subject.id).to be > 0
          expect(subject.data.to_json).to eq(data.to_json)
        end

        it 'allows other properties defined on schema' do
          data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com', title: 'Software Engineer', company: 'Example.com' }

          subject.ticket_class = create(:ticket_class, event: create(:published_future_event))
          subject.data = data

          expect(subject).to receive(:payment_intent_id).and_return('pi_q23e')

          result = subject.save

          expect(result).to eq(true)
          expect(subject.id).to be > 0
          expect(subject.data.to_json).to eq(data.to_json)
        end

        it 'does not accept extra properties' do
          subject.ticket_class = create(:ticket_class, event: create(:published_future_event))
          subject.data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com', extra: 'property'}

          result = subject.save

          expect(result).to eq(false)

          expect(
            subject.errors.messages[:data][0]
          ).to include(
            "contains additional properties [\"extra\"] outside of the schema when none are allowed"
          )
        end

        it 'provides errors for missing required properties' do
          subject.ticket_class = create(:ticket_class, event: create(:event))
          subject.data = {}

          result = subject.save

          expect(result).to eq(false)

          expect(
            subject.errors.messages[:data][0]
          ).to include(
            "can't be blank"
          )

          expect(
            subject.errors.messages[:data][1]
          ).to include(
            "did not contain a required property of 'firstName'"
          )

          expect(
            subject.errors.messages[:data][2]
          ).to include(
            "did not contain a required property of 'lastName'"
          )

          expect(
            subject.errors.messages[:data][3]
          ).to include(
            "did not contain a required property of 'email'"
          )
        end
      end
    end
  end
end
