class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  before_action :configure_permitted_parameters, if: :devise_controller?

  def render_404
    render template: 'errors/not_found', status: :not_found
  end

  def not_found_route
    render_404
  end

  def render_403
    render template: 'errors/not_allowed', status: :forbidden
  end

  def not_allowed_route
    render_403
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
  end
end
