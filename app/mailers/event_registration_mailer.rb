class EventRegistrationMailer < ApplicationMailer
  def confirmation_email
    subject = 'Confirmed! You\'re on the list'

    @event_registration = params[:event_registration]
    
    raise 'Event Registration not valid' unless @event_registration.valid?

    @event = @event_registration.event

    @display = {
      recipient: {
        first_name: recipient['firstName']
      },
      event: {
        date: date_display,
        time: time_display,
      },
      venue: {
        address: address_display(@event.venue)
      }
    }

    mail(to: recipient['email'], subject: subject)
  end

  private

  def recipient
    @event_registration.data
  end

  def time_display
    strftime = '%l:%M %p'
    timezone_strttime = ' %Z'

    start = @event.starting_at.in_time_zone(TIME_ZONE)
    _end = @event.ending_at.in_time_zone(TIME_ZONE)

    if @event.single_day_event?
      start.strftime(strftime) + ' - ' + _end.strftime(strftime + timezone_strttime)
    else
      start.strftime(strftime + timezone_strttime)
    end
  end

  def date_display
    strftime = '%A, %B %d, %Y'
    start = @event.starting_at.in_time_zone(TIME_ZONE)
    _end = @event.ending_at.in_time_zone(TIME_ZONE)

    if @event.single_day_event?
      start.strftime(strftime)
    else
      start.strftime(strftime) + ' - ' + _end.strftime(strftime)
    end
  end

  def address_display(venue)
    venue&.address&.values&.join(' ')
  end
end
