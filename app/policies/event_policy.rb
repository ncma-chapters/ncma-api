class EventPolicy < ApplicationPolicy
  def create?
    false
  end
end
