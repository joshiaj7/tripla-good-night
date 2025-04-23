# frozen_string_literal: true

module WatchlistService
  class CreateOrUpdate < Base
    def initialize(params)
      @follower_id = params[:follower_id].to_i
      @followed_id = params[:followed_id].to_i
      @active = params[:active].present? ? params[:active] : false
    end

    def perform
      validate!

      followed_user = User.find_by(id: @followed_id)
      raise ::BaseError::UserNotFoundError.new if followed_user.nil?

      watchlist = Watchlist.find_by(follower_id: @follower_id, followed_id: followed_user.id)

      # if watchlist not found, create a new one
      if watchlist.nil?
        watchlist = Watchlist.new(follower_id: @follower_id, followed_id: @followed_id, active: @active)
        watchlist.save!
        return watchlist
      end

      # if watchlist found and active is different from current value
      # update the active status
      if watchlist.active != @active
        watchlist.update!(active: @active)
      end

      watchlist
    end

    def validate!
      raise ::BaseError::UserUnauthorizedError.new if @follower_id <= 0
      raise ::BaseError::InvalidParameterError.new("followed_id") if @followed_id <= 0
      raise ::BaseError::FollowingYourselfError.new if @follower_id == @followed_id
    end
  end
end
