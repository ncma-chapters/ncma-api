class HooksController < ActionController::API
  STRIPE_WEBHOOK_SIGNING_SECRET = ENV['STRIPE_WEBHOOK_SIGNING_SECRET']

  def stripe
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    payload = request.body.read

    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, signature_header, STRIPE_WEBHOOK_SIGNING_SECRET)
    rescue JSON::ParserError => e
      render json: { error: 'JSON::ParserError' }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # For more details visit: https://stripe.com/docs/webhooks/signatures
      render json: { error: 'Stripe::SignatureVerificationError' }, status: :bad_request
      return
    end

    if event.type == 'payment_intent.succeeded'
      payment_intent = event.data.object # Stripe::PaymentIntent

      # Create an EventRegistration after merging the metadata stored on the Stripe::PaymentIntent
      registration = EventRegistration.create!(
        data: payment_intent.metadata['registration.data'],
        payment_intent_id: payment_intent.id,
        ticket_class_id: payment_intent.metadata['ticket_class_id'],
      )

      # Send the confirmation email
      EventRegistrationMailer.with(event_registration: registration).confirmation_email.deliver_now

      render json: { data: registration }, status: :created
    end
  end
end
