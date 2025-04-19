class UserController < ApplicationController
  def signup
    # call signup service
    UserService.sign_up(params.permit(:name).to_h)

    render_response message: "User created successfully"
  rescue => e
    render_error e
  end
end
