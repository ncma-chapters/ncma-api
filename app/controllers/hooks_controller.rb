class HooksController < ActionController::API
  def stripe
    payload = request.body.read
    event = nil

    begin
      event = Stripe::Event.construct_from(
        # TODO: pass headers['HTTP_STRIPE_SIGNATURE'] to #construct_from
        # implementation: https://stripe.com/docs/webhooks/signatures
        JSON.parse(payload, symbolize_names: true)
      )
    rescue JSON::ParserError => e
      render json: { error: 'JSON::ParserError' }, status: :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature. For more details visit: https://stripe.com/docs/webhooks/signatures
      render json: { error: 'Stripe::SignatureVerificationError' }, status: :bad_request
      return
    end

    if event.type == 'payment_intent.succeeded'
      target_payment_intent = event.data.object # Stripe::PaymentIntent

      # Fetch the payment intent to ensure it exists in stripe
      payment_intent = Stripe::PaymentIntent.retrieve(target_payment_intent.id)

      # Create an EventRegistration after merging the metadata stored on the payment intent
      registration = EventRegistration.create!(
        data: payment_intent.metadata['registration.data'].to_json,
        payment_intent_id: payment_intent.id,
        ticket_class_id: payment_intent.metadata['ticket_class_id'],
      )

      # Send the confirmation email
      EventRegistrationMailer.with(event_registration: registration).confirmation_email.deliver_now

      render json: { data: registration }, status: :created
    end
  end
end
