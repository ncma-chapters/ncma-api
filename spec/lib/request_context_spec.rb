require 'rails_helper'

RSpec.describe RequestContext, :type => :model do
  describe 'initialize' do
    it 'accepts user' do
      user_data = double

      subject = described_class.new(user: user_data)
      expect(subject.user).to eq(user_data)
    end
  end
end
