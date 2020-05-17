require "rails_helper"

RSpec.describe EventRegistrationMailer, type: :mailer do
  describe '#deliver_now' do
    before do
      @event = create(:published_future_event_with_venue, name: 'AMA Webinar')
      @ticket_class = create(:ticket_class, event_id: @event.id, price: 0, name: 'General Registration')
      @registration = create(
        :event_registration,
        ticket_class: @ticket_class,
        event: @event,
        data: {
          firstName: 'Kevin',
          lastName: 'Mircovich',
          email: 'kevin@ncmamonmouth.org'
        })

      @mail = described_class.with(event_registration: @registration).confirmation_email
    end

    after do
      @ticket_class.event_registrations.destroy_all
      @ticket_class.destroy
      deleted_event = @event.destroy
      deleted_event.venue.destroy
    end

    it 'renders the headers' do
      expect(@mail.subject).to eq('Confirmed! You\'re on the list')
      expect(@mail.to).to eq(['kevin@ncmamonmouth.org'])
      expect(@mail.from).to eq(['events@ncmamonmouth.org'])
      expect(@mail.reply_to).to eq(['info@ncmamonmouth.org'])
    end
  end
end
