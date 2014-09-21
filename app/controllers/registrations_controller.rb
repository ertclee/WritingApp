class RegistrationsController < Devise::RegistrationsController
	prepend_before_filter :authenticate_scope!, :only => [:change_password]

	def change_password
		@user = User.find(current_user.id)
	end

	def edit 
		@user = User.find(current_user.id)
	    @email = current_user.email
	    @profile = Profile.find_by user_id: current_user.id
	end

	def update
		if account_update_params[:password].blank?
			account_update_params.delete("password")
			account_update_params.delete("password_confirmation")
		end
	    @user = User.find(current_user.id)
	    @email = current_user.email
	    successfully_updated = if needs_password?(@user, params)
	    	# puts "is the password valid?", valid_password?(params[:current_password])
	    	puts "sanitized values are ", devise_parameter_sanitizer.sanitize(:account_update)
	        @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
	    else
	    	
	    	@user.email = params[:user][:email] 	
	    	@user.save!
	      # remove the virtual current_password attribute
	      # update_without_password doesn't know how to ignore it
	      # params[:user].delete(:current_password)
	      # # @user.update_attribute(:email, current_user.email)
	      # puts "enters here333"
	      # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email) }
	      # @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
	      # @user.update_without_password(devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email) })
	    end
	    puts "is successful? ", successfully_updated
	    if successfully_updated
	      set_flash_message :notice, :updated
	      # Sign in the user bypassing validation in case their password changed
	      sign_in @user, :bypass => true
	      redirect_to after_update_path_for(@user)
	    else
	      render "edit"
	    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)

    (user.email == params[:user][:email]) ||
      params[:user][:email].present?
      params[:user][:password].present? ||
      params[:user][:password_confirmation].present?
  end

  protected
  def after_inactive_sign_up_path_for(resource)
    "/users/show"
  end
end