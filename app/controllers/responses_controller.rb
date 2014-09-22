class ResponsesController < ApplicationController
	before_filter :auth_user, only: [:create]
	def new
		@challenge = WritingChallenge.find(params[:writing_challenge_id])
		@response = Response.new
		if current_user
			@profile = Profile.find_by user_id: current_user.id
		end
	end

	def create
	    @challenge = WritingChallenge.find(params[:writing_challenge_id])
	    @response = Response.new(response_params)
	    @response.writing_challenge_id = params[:writing_challenge_id]
	    @response.time = Date.today
	    @response.wordcount = @response.response.split.size
	    @response.writer = current_user.name
	    current_user.responses << @response
	    respond_to do |format|
	    	if @response.save
	    		format.html { redirect_to writing_challenge_response_path(params[:writing_challenge_id], @response.id), notice: 'Response was successfully made.' }
	    	end
	    end
	end

	def edit
		@challenge = WritingChallenge.find(params[:writing_challenge_id])
		# puts @response.inspect
		@profile = Profile.find_by user_id: current_user.id
		@responses = Response.where("writing_challenge_id = ? AND writer = ?", params[:writing_challenge_id], current_user.name)
		@responses.each do|res|
			@response = res
		end
	end

	def update
		@response = Response.find(params[:id])
	  	if @response.update_attributes(response_params)
	  		@response.update(:time => Date.today, :wordcount => @response.response.split.size)
	  		flash[:success] = "Your Response was successfully updated!"
	    	redirect_to writing_challenge_response_path(params[:writing_challenge_id], @response.id)
	  	else
	    	render "edit"
	  	end
	end

	private
	    def response_params
	    	params.require(:response).permit(:response, :prompt_id, :user, :time, :writer, :wordcount, :writing_challenge_id)
	    end

	    def auth_user
	    	@challenge = WritingChallenge.find(params[:writing_challenge_id])
		    @response = Response.new(response_params)
		    @response.writing_challenge_id = params[:writing_challenge_id]
		    @response.time = Date.today
	    	@response.wordcount = @response.response.split.size
	    	@response.save!
	    	redirect_to new_user_registration_path unless user_signed_in?
	    end
end
