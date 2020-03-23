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
      it 'validates the presence of a ticket_class' do
        expect(subject.save).to eq(false)

        expect(subject.errors.messages[:ticket_class][0]).to eq('must exist')
        expect(subject.errors.details[:ticket_class][0]).to eq({ :error=>:blank })
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
      end

      describe 'validating #data' do
        it 'validates #data against its event\'s registration_schema when after properties are valid' do
          data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com' }

          subject.ticket_class = create(:ticket_class, event: create(:published_future_event))
          subject.data = data

          result = subject.save

          expect(result).to eq(true)
          expect(subject.id).to be > 0
          expect(subject.data.to_json).to eq(data.to_json)
        end

        it 'allows other properties defined on schema' do
          data = { firstName: 'Kevin', lastName: 'Mirc', email: 'kevin@example.com', title: 'Software Engineer', company: 'Example.com' }

          subject.ticket_class = create(:ticket_class, event: create(:published_future_event))
          subject.data = data

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

        it 'provides errors for missing required properties properties' do
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
