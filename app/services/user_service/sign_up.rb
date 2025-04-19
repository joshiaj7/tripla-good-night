# frozen_string_literal: true

module UserService
  class SignUp < Base
    def initialize(params)
      @name = params[:name]
    end

    def perform
      validate!

      user = User.new
      user.name = @name
      user.save!
    end

    def validate!
      raise ::BaseError::InvalidParameterError.new("name") if @name.blank?
    end
  end
end
