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

  def after_sign_in_path_for(resource)
    puts "enters here"
    daily_challenge_path
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
  
  require 'socket'
  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  def find_response_with_matching_ip_address(responses, local_ip)
    puts "enters here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    responses.each do |response|
      puts "response ip adress is ", response.ip_address
      puts "local_ip is ", local_ip
      if response.ip_address == local_ip
        puts "enters the equality of ip address!!!!!!!"
        puts "response is ", response
        return response
      end
    end
    puts "end of the loop"
  end
end
