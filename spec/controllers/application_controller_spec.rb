require 'rails_helper'

class TestController < ApplicationController; end

RSpec.describe ApplicationController, :type => :controller do
  controller TestController do
    def action_1
      raise JWT::DecodeError
    end

    def action_2
      raise JWT::ExpiredSignature, 'Expired Token...'
    end

    def action_3
      raise Pundit::NotAuthorizedError, 'You can\'t do this...'
    end
  end

  describe 'error handling' do
    context 'on JWT::DecodeError' do
      it 'renders 401' do
        action = :action_1
        routes.draw { get action.to_s => "test##{action.to_s}" }

        get action

        expect(response.status).to eq(401)
        expect(JSON(response.body)).to eq({ 'error' => 'Unauthorized' })
      end
    end

    context 'on JWT::ExpiredSignature' do
      it 'renders 401 with context' do
        action = :action_2
        routes.draw { get action.to_s => "test##{action.to_s}" }

        get action

        expect(response.status).to eq(401)
        expect(JSON(response.body)).to eq(
          {
            'error' => 'Unauthorized',
            'type' => 'JWT::ExpiredSignature',
            'message' => 'Expired Token...'
          }
        )
      end
    end

    context 'on Pundit::NotAuthorizedError' do
      it 'renders 403 with context' do
        action = :action_3
        routes.draw { get action.to_s => "test##{action.to_s}" }

        get action

        expect(response.status).to eq(403)
        expect(JSON(response.body)).to eq(
          {
            'error' => 'Forbidden',
            'message' => 'You can\'t do this...'
          }
        )
      end
    end
  end

  describe '#context' do
    describe 'when auth header is not present' do
      it 'a RequestContext with a nil user' do
        request = double(authorization: nil)

        expect(subject).to receive(:request).and_return(request).at_least(1).times

        expect(subject.context).to be_instance_of(RequestContext)
        expect(subject.context.user).to eq(nil)
      end
    end

    describe 'when auth header is poorly formatted' do
      it 'raises JWT::DecodeError' do
        request = double(authorization: 'bad.jwt.token')

        expect(subject).to receive(:request).and_return(request).at_least(1).times

        expect { subject.context }.to raise_error(JWT::DecodeError)
      end
    end

    describe 'when auth header is invalid' do
      context 'when expired' do
        it 'raises JWT::ExpiredSignature ' do
          token = JWT.encode({ exp: 1 }, 'secret')
          request = double(authorization: "Bearer #{token}")

          expect(subject).to receive(:request).and_return(request).at_least(2).times

          expect { subject.context }.to raise_error(JWT::DecodeError, 'Signature has expired')
        end
      end
    end

    describe 'when auth header is valid' do
      context 'when expired' do
        it 'raises JWT::ExpiredSignature ' do
          token_payload = {
            'sub' => SecureRandom.uuid,
            'iat' => DateTime.now.to_i,
            'exp' => (DateTime.now + 1.hour).to_i,
            'cognito:groups' => ['Admin']
          }

          token = JWT.encode(token_payload, 'secret')
          request = double(authorization: "Bearer #{token}")

          expect(subject).to receive(:request).and_return(request).at_least(2).times

          expect(subject.context).to be_instance_of(RequestContext)
          expect(subject.context.user).to be_instance_of(RequestContext::User)
          expect(subject.context.user.original_payload).to eq(token_payload)
        end
      end
    end
  end
end
