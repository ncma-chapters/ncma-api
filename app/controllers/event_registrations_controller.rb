class EventRegistrationsController < ApplicationController
  def create
    begin
      registration = EventRegistration.new(attributes)      
    rescue Exception => e
      # If it fails because params (#attributes) were not valid
      # let JSONAPI hit the same error and render a formatted response
      return process_request
    end

    if registration.only_requires_payment?
      # (1) Create a payment intent and set :payment_intent_id
      registration.create_payment_intent

      # (2) Ensure it's now valid (will need to raise 500 if not)
      unless registration.valid?
        raise 'Failure to make a valid paid registration'
      end

      # [SKIP] (3) Cache the model (exp in 20 min - 15 min on client, 5 min leeway for proccessing)

      # (4) Render render_action_required # { payment_intent_id: 'df', client_secret: '23453' }
      render_pending_registration registration
    else
      process_request
    end
  end

  private

  def render_pending_registration(registration)
    payment_intent = registration.payment_intent

    render json: {
      data: {
        id: nil,
        type: 'eventRegistrations',
        attributes: {
          id: registration.id,
          data: registration.data,
          ticketClassId: registration.ticket_class_id,
          createdAt: registration.created_at,
          updatedAt: registration.updated_at
        },
      },
      meta: {
        clientSecret: payment_intent.client_secret,
        paymentIntent: {
          id: payment_intent.id,
          object: payment_intent.object,
          status: payment_intent.status,
          clientSecret: payment_intent.client_secret,
          amount: payment_intent.amount
        }
      }
    }, status: 202
  end

  def attributes
    { data: params__data, ticket_class_id: params__ticket_class_id }
  end

  def params__data
    params.require(:data).require(:attributes).require(:data)
  end

  def params__ticket_class_id
    params.require(:data).require(:relationships).require(:ticketClass).require(:data).require(:id)
  end
end
