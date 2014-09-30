class SessionsController < Devise::SessionsController
	def create
		@response = Response.last
		@user = User.where("email = ? ", params["user"]["email"])
		@daily_challenge = WritingChallenge.daily
		@user = @user[0]
		puts @user.inspect
	    if @response.present? && @response.writer.nil? 
	    	if @user.responses.present? 
	    		@user.responses.each do |response|
	    			if response.writing_challenge_id == @daily_challenge.id
	    				@response.destroy
	    				flash[:error] = "You've already saved a response to today's challenge."
	    				daily_challenge_path
	    			end
	    		end
	    	else 
	    		@response.update_attribute(:writer, @user.name)
	      		@response.update_attribute(:user_id, @user.id)
	    	end
	    end
		super
	end
end
