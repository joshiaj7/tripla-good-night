# frozen_string_literal: true

module WatchlistService
  module_function

  def create_or_update(*args); WatchlistService::CreateOrUpdate.new(*args).call; end
end
