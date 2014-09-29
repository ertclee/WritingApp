class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
    devise_parameter_sanitizer.for(:sign_up) << :timezone
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :current_password)
    end
  end

  def after_inactive_sign_up_path_for(resource)
    render 'devise/registrations/show.html.erb'
  end

  

  def after_sign_up_path_for(resource)
    profile_path(resource)
  end

  def stored_location_for(resource)
    nil
  end

  

  def after_sign_out_path_for(resource)
    daily_challenge_path
  end
  
end
