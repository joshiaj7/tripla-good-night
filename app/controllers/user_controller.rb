class UserController < ApplicationController
  def signup
    # call signup service
    user_params = { name: params[:name] }
    user = UserService.sign_up(user_params)

    render_response({ id: user.id, name: user.name })
  rescue => e
    render_error e
  end

  def login
    # call login service
    login_params = { id: params[:id].to_i }
    token = UserService.log_in(login_params)

    render_response({ token: token })
  rescue => e
    render_error e
  end
end
