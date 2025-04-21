class ScheduleController < ApplicationController
  def clock_in
    clock_in_params = { user_id: current_user_id }
    ScheduleService.clock_in(clock_in_params)

    render_response(message: "clock in successfully")
  rescue => e
    render_error e
  end
end
