class WatchlistController < ApplicationController
  def follow
    watchlist_params = {
      follower_id: current_user_id.to_i,
      followed_id: params[:followed_id].to_i,
      active: true
    }
    WatchlistService.create_or_update(watchlist_params)

    render_response message: "followed successfully"
  rescue => e
    render_error e
  end

  def unfollow
    watchlist_params = {
      follower_id: current_user_id.to_i,
      followed_id: params[:followed_id].to_i,
      active: false
    }
    WatchlistService.create_or_update(watchlist_params)

    render_response message: "unfollowed successfully"
  rescue => e
    render_error e
  end
end
