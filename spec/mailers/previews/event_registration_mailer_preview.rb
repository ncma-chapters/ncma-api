# Preview all emails at http://localhost:3000/rails/mailers/event_registration_mailer
class EventRegistrationMailerPreview < ActionMailer::Preview
  def confirmation_email
    event = FactoryBot.create(
      :published_future_event_with_ticket_classes,
      name: 'Luncheon',
      starting_at: DateTime.now + 1.day,
      ending_at: DateTime.now + 1.day + 2.hours,
      venue: FactoryBot.create(
        :venue,
        name: 'Jersey Diner',
        address: {
          street: '123 Barnaby Way',
          city: 'Point Pleasant',
          state: 'NJ',
          zip: '04326'
        }
      )
    )

    event_registration = FactoryBot.create(
      :event_registration,
      ticket_class: event.ticket_classes.last
    )

    EventRegistrationMailer.with(event_registration: event_registration).confirmation_email
  end
end
