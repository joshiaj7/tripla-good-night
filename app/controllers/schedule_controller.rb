class ScheduleController < ApplicationController
  def clock_in
    clock_in_params = { user_id: current_user_id }
    ScheduleService.clock_in(clock_in_params)

    render_response(message: "clock in successfully")
  rescue => e
    render_error e
  end

  def leaderboards
    leaderboard_params = {
      user_id: current_user_id.to_i,
      limit: params[:limit].to_i,
      offset: params[:offset].to_i
    }
    result, meta = ScheduleService.get_leaderboard(leaderboard_params)

    render_response(body=result, meta=meta)
  rescue => e
    render_error e
  end
end
