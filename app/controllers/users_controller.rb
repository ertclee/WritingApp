class UsersController < ApplicationController
  def check_unique_username
    render :json => true unless params[:user][:email]
    user = User.find_by(email: params[:user][:email])
    if user.present?
  		render json: "Email already taken.", status: :unprocessable_entity
  	else
      puts "enters here"
    	render :json => true 
  	end
  end

  def check_if_email_confirmed
  	render :json => true unless params[:user][:email]
  	user = User.find_by(email: params[:user][:email])
  	if  !user.present?
  		render json: "Email not found. Sign up first.", status: :unprocessable_entity
  	elsif user.confirmation_token
  		render :json => true 
  	else 
  		render json: "Email was already confirmed, Please log in.", status: :unprocessable_entity
  	end
  end

  def check_if_email_exists 
  	render :json => true unless params[:user][:email]
    user = User.find_by(email: params[:user][:email])
    session[:email] = params[:user][:email]
    if user.present?
  		render :json => true
  	else
    	render json: "That email doesn't exist. Please sign up.", status: :unprocessable_entity 
  	end
  	return params[:user][:email]
  end  

  def password_match?
  	if params[:user][:password] == params[:user][:password_confirmation]
  		render :json => true
  	else 
  		render json: "Passwords do not match.", status: :unprocessable_entity
  	end
  end


  def password_correct?
    user = User.find_by(email: session[:email])
    if !user
      render json: "Password doesn't exist for this account.", status: :unprocessable_entity
    elsif !user.valid_password?(params[:user][:password])
    	render json: "Password is incorrect. Please check it again.", status: :unprocessable_entity 
    else 
    	render :json => true
    end
  end

  
end