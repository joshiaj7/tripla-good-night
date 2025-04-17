class UserController < ApplicationController
  def signup
    # call signup service
    UserService.sign_up(params)

    render_response message: "User created successfully"
  rescue => e
    render_error e
  end
end
