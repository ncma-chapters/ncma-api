class RequestContext
  attr_reader :user

  def initialize(args)
    @user = args[:user]
  end
end
