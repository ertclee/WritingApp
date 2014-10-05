class SessionsController < Devise::SessionsController
	def create
		#@response = Response.last #When user submits a response and tries to log in, it gets the response that the user just created. This isn't the right solution. 
		@user = User.where("email = ? ", params["user"]["email"])
		@daily_challenge = WritingChallenge.daily
		@user = @user[0]
		puts @response.inspect
		puts @user.inspect
		@no_duplicate = true
		@ip_address = local_ip
		@responses_with_no_writers = []
		@responses = Response.all
		@responses.each do |response|
			if response.writer.nil? 
				@responses_with_no_writers.push(response)
			end
		end
	    @response = find_response_with_matching_ip_address(@responses_with_no_writers, @ip_address)
	    if @response.present? 
	    	if @response.writer.nil? 
		    	puts "enters response present and response writer nil"
		    	if @user.responses.present?
		    		puts "responses present"
		    		@user.responses.each do |response|
		    			puts "enters loop"
		    			if response.writing_challenge_id == @response.writing_challenge_id
		    				puts "they are equal"
		    				@response.destroy
		    	 			
		    	 		else
		    	 			@no_duplicate = false
		    	 		end
		    		end
		    	end
		    end
		    if !@no_duplicate
	    		@response.update_attribute(:writer, params["user"]["email"])
	        	@response.update_attribute(:user_id, @user.id)
	        else 
	        	puts "enters here in the flashing!!!!!!"
	        	flash[:error] = "You've already saved a response to today's challenge."
	    	 	daily_challenge_path
	    	end
	    	# if @user.responses.present? 
	    	# 	puts "user has responses"
	    	# 	@user.responses.each do |response|
	    	# 		if response.writing_challenge_id == @daily_challenge.id
	    	# 			puts "response writing challenge id is same as daily writing challenge id"
	    	# 			@response.destroy
	    	# 			flash[:error] = "You've already saved a response to today's challenge."
	    	# 			daily_challenge_path
	    	# 		end
	    	# 	end
	    	# else 
	    	# 	puts "user doesn't have any responses."
	    	# 	@response.update_attribute(:writer, @user.name)
	        #  	@response.update_attribute(:user_id, @user.id)
	    	# end
	    end
		super
	end
end
