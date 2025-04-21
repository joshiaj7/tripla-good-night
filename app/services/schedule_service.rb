# frozen_string_literal: true

module ScheduleService
  module_function

  def clock_in(*args); ScheduleService::ClockIn.new(*args).call; end
  def record(*args); ScheduleService::Record.new(*args).call; end
end
