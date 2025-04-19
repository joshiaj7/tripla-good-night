# frozen_string_literal: true

module UserService
  module_function

  def log_in(*args); UserService::LogIn.new(*args).call; end
  def sign_up(*args); UserService::SignUp.new(*args).call; end
end
