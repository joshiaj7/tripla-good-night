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
      @status  = 422
    end
  end
end
