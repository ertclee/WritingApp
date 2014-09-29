class ProfilesController < ApplicationController
	def edit
		@daily_challenge = WritingChallenge.daily
	   	@profile = Profile.find_by user_id: current_user.id
	   	if !@profile.name
	   		@name = current_user.name
	   	else
	   		@name = @profile.name
	   	end
	   	@send_me_daily_challenge = @profile.daily_email_reminder
	   	@attributes = Profile.attribute_names - %w(id user_id created_at updated_at)
	end

	def profile

  	end

  	def show
  		redirect_to root_path
  		puts params
  	end

  	def update
		@profile = Profile.find_by user_id: current_user.id
		@daily_goal = params[:profile][:daily_goal]
		@profile.update_attribute(:daily_goal, @daily_goal)
		puts params
		if params[:profile][:daily_email_reminder] == '1'
			@profile.update_attribute(:daily_email_reminder, true)
		else
			@profile.update_attribute(:daily_email_reminder, false)
		end

		if params[:profile][:photo]
			@profile.update_attribute(:image, params[:profile][:photo])
		end
		
		@profile.update_attribute(:name, params[:profile][:name])
		
		if @profile.update_attributes(user_params)
			@profile.save
			flash[:success] = "Your profile was successfully updated!"
			redirect_to my_profile_path
		else
			render 'edit'
		end
	end

	private

    def user_params
    	params.require(:profile).permit(:user_id, :image, :name)
    end
end
