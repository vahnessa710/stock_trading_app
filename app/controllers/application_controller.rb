class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def after_sign_in_path_for(resource)
    resource.role == 'admin' ? admin_users_path : authenticated_root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :location, :phone])
  end

  private
  
  def authenticate_admin!
    unless current_user&.admin?
      redirect_to holdings_path, alert: "Traders are not authorized to access this page."
    end
  end

  def authenticate_trader!
    if current_user&.admin?
      redirect_to admin_users_path, alert: "Admins are not authorized to access this page."
    end
  end

  def record_not_found
    redirect_to admin_users_path, alert: 'record does not exist'
  end
end
