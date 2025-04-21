class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  skip_before_action :verify_authenticity_token

  def current_user_id
    # check user from jwt token
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ")[1]
      decoded_token = JsonWebToken.decode(token)
      @current_user_id = decoded_token["sub"] if decoded_token
    else
      raise ::BaseError::UserUnauthorizedError.new
    end
    @current_user_id
  rescue JWT::ExpiredSignature => e
    # handle expired token
    render json: { error: e.message }, status: :unauthorized
  end

  # rescue from all errors and render the error message
  def render_response(body = nil, meta = nil, status = :ok, message = nil)
    if body.present?
      result = { data: body }
      result[:meta] = meta if meta.present?

      render json: result, status: status
    else
      render json: { message: message }, status: :ok
    end
  end

  # rescue from all errors and render the error message
  def render_error(error)
    if error.is_a?(BaseError::GeneralError)
      render json: { error: error.message }, status: error.status
    else
      render json: { error: error.message }, status: :internal_server_error
    end
  end
end
