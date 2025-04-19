# frozen_string_literal: true

module UserService
  class LogIn < Base
    def initialize(params)
      @id = params[:id].to_i
    end

    def perform
      validate!

      user = User.find(@id)
      JsonWebToken.encode({ sub: user.id })
    rescue ActiveRecord::RecordNotFound
      raise ::BaseError::UserNotFoundError.new
    end

    def validate!
      raise ::BaseError::InvalidParameterError.new("id") if @id.nil? || @id <= 0
    end
  end
end
