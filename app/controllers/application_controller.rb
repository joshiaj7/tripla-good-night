class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  skip_before_action :verify_authenticity_token

  # rescue from all errors and render the error message
  def render_response(body = nil, status = :ok, message = nil)
    if body.present?
      render json: body, status: status
    else
      render json: { message: message }, status: :ok
    end
  end

  # rescue from all errors and render the error message
  def render_error(error)
    render json: { error: error.message }, status: error.status
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
