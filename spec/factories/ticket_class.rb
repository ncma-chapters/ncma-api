FactoryBot.define do
  factory :ticket_class do
    name { 'General Admission' }
    price { 25.50 }
    event { create(:event) }
  end
end
