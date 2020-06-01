class EventRegistrationProcessor < JSONAPI::Processor
  before_find :authorize_find

  private

  def authorize_find
    passcode = params[:serializer].link_builder.url_helpers.params.require(:passcode)

    unless passcode == ENV['ATTENDEE_LIST_PASSCODE']
      message = "Not authorized to view #{EventRegistration.name.titleize.pluralize}"
      raise Pundit::NotAuthorizedError, message
    end
  end
end
