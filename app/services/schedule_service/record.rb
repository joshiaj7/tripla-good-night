# frozen_string_literal: true

module ScheduleService
  class Record < Base
    def initialize(params)
      @user_id = params[:user_id].to_i
      @clocked_in_at = params[:clocked_in_at].to_datetime
    end

    def perform
      validate!

      user = User.find_by(id: @user_id)
      raise ::BaseError::UserNotFoundError.new if user.nil?

      # check if the user has already clocked in
      latest_schedule = Schedule.where(user_id: @user_id).order(created_at: :desc).first

      # if the user clocked in for the first time
      # create a new schedule record
      if latest_schedule.nil?
        schedule = Schedule.new(user_id: @user_id, clocked_in_at: @clocked_in_at)
        schedule.save!
        return schedule
      end

      if latest_schedule.clocked_in_at.present? && latest_schedule.clocked_out_at.nil?
        # if the user clocked in before but not clocked out yet
        # add the clock out time and duration to the latest schedule record
        latest_schedule.clocked_out_at = @clocked_in_at
        latest_schedule.duration_in_seconds = (@clocked_in_at.to_time - latest_schedule.clocked_in_at.to_time).to_i
        latest_schedule.save!
        schedule = latest_schedule
      elsif latest_schedule.clocked_in_at.present? && latest_schedule.clocked_out_at.present? && latest_schedule.duration_in_seconds.present?
        # if the user clocked in and clocked out before
        # create a new schedule record
        schedule = Schedule.new(user_id: @user_id, clocked_in_at: @clocked_in_at)
        schedule.save!
      end

      schedule
    end

    def validate!
      raise ::BaseError::InvalidParameterError.new("user_id") if @user_id <= 0
      raise ::BaseError::InvalidParameterError.new("clocked_in_at") if @clocked_in_at.nil?
    end
  end
end
