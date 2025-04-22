# frozen_string_literal: true

module ScheduleService
  class GetLeaderboard < Base
    DEFAULT_LIMIT = 10
    DEFAULT_OFFSET = 0

    def initialize(params)
      @user_id = params[:user_id].to_i
      @limit = params[:limit].to_i <= 0 ? DEFAULT_LIMIT : params[:limit].to_i
      @offset = params[:offset].to_i < 0 ? DEFAULT_OFFSET : params[:offset].to_i
    end

    def perform
      validate!

      user = User.find_by(id: @user_id)
      raise ::BaseError::UserNotFoundError.new if user.nil?

      followed_user_ids = user.active_watchlists.pluck(:followed_id)

      schedules = Schedule.where(user_id: followed_user_ids)
      schedules = schedules.where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
      schedules = schedules.order(duration_in_seconds: :desc)
      schedules = schedules.limit(@limit).offset(@offset)
      schedules = schedules.to_a

      return map_schedules_and_users(schedules.to_a), {
        total_count: schedules.count,
        limit: @limit,
        offset: @offset
      }
    end

    def validate!
      raise ::BaseError::UserUnauthorizedError.new if @user_id <= 0
    end

    def map_schedules_and_users(schedules)
      followed_users = User.where(id: schedules.pluck(:user_id)).to_a
      followed_users_map = followed_users.index_by(&:id)

      result = []
      for schedule in schedules
        result << {
          schedule_id: schedule.id,
          duration_in_seconds: schedule.duration_in_seconds,
          user_name: followed_users_map[schedule.user_id].name
        }
      end
      result
    end
  end
end
