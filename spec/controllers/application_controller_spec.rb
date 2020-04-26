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

        res_body = JSON(response.body)
        expect(res_body).to eq({ 'error' => 'Unauthorized' })
      end
    end

    context 'on JWT::ExpiredSignature' do
      it 'renders 401 with context' do
        action = :action_2
        routes.draw { get action.to_s => "test##{action.to_s}" }

        get action

        expect(response.status).to eq(401)

        res_body = JSON(response.body)
        expect(res_body).to eq(
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

        res_body = JSON(response.body)
        expect(res_body).to eq(
          {
            'error' => 'Forbidden',
            'message' => 'You can\'t do this...'
          }
        )
      end
    end
  end
end
