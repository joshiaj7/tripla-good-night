class UserController < ApplicationController
  def signup
    # call signup service
    user_params = { name: params[:name] }
    user = UserService.sign_up(user_params)

    render_response body: { id: user.id, name: user.name }
  rescue => e
    render_error e
  end
end
