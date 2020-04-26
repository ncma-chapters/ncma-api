class EventPolicy < ApplicationPolicy
  def create?
    user_is_event_manager
  end

  def update?
    user_is_event_manager
  end
end
