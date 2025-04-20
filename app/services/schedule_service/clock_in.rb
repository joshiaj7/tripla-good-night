# frozen_string_literal: true

module ScheduleService
  class ClockIn < Base
    def initialize(params)
      @user_id = params[:user_id].to_i
    end

    def perform
      validate!

      user = User.find_by(id: @user_id)
      raise ::BaseError::UserNotFoundError.new if user.nil?

      KafkaClient.deliver_message({ user_id: @user_id, clock_in_at: Time.now.utc }.to_json, topic: "schedule-clock-in")
    end

    def validate!
      raise ::BaseError::UserUnauthorizedError.new if @user_id <= 0
    end
  end
end
