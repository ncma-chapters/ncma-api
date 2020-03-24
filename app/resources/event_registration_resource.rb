class EventRegistrationResource < ApplicationResource  
  has_one :ticket_class
  
  attributes :data
end