module BaseError
  class GeneralError < ::StandardError
    attr_reader :message, :status

    def initialize(message, status = 422)
      @message = message
      @status  = status
    end
  end

  class InvalidParameterError < GeneralError
    def initialize(param = nil)
      if param.present?
        @message = "invalid parameter: #{param}"
      else
        @message = "invalid parameter"
      end
      @status  = 400
    end
  end

  class UserNotFoundError < GeneralError
    def initialize
      @message = "user not found"
      @status  = 404
    end
  end

  class UserUnauthorizedError < GeneralError
    def initialize
      @message = "user is unauthorized"
      @status  = :unauthorized
    end
  end

  class FollowingYourselfError < GeneralError
    def initialize
      @message = "you can not follow yourself"
      @status  = :unprocessable_entity
    end
  end
end
