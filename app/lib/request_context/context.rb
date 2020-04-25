module RequestContext
  class Context

    attr_reader :user

    def initialize(args)
      @user = args[:user]
    end
  end
end
