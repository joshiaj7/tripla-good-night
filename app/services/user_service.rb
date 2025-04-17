# frozen_string_literal: true

module UserService

  module_function

  def sign_up(*args); UserService::SignUp.new(*args).call; end
end
