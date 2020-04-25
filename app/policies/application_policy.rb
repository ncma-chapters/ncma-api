class ApplicationPolicy
  attr_reader :user, :model

  def initialize(user, model)
    @user = user
    @model = model
  end

  private

  def user_is_event_manager
    @user ? @user.in_group('EventManagers') : false
  end
end
