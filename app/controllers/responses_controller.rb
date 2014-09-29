class ResponsesController < ApplicationController
	before_filter :auth_user, only: [:create]
	before_filter :daily_challenge, only: [:new]
	before_filter :edit_daily_challenge, only: [:edit]
	before_filter :daily_challenge_redirect, only: [:index]
	def index
		@challenge = WritingChallenge.new
	end

	def new
		@response = Response.new
		if current_user
			@profile = Profile.find_by user_id: current_user.id
		end
	end

	def create
	    @challenge = WritingChallenge.where("slug = ? ", params[:writing_challenge_title])
	    @challenge = @challenge[0]
	    puts "challenge is ", @challenge.inspect
	    @response = Response.new(response_params)
	    @response.writing_challenge_id = @challenge.id 
	    @response.time = Date.today
	    @response.wordcount = @response.response.split.size
	    @response.writer = current_user.name
	    @response.slug = params[:writing_challenge_title]
	    current_user.responses << @response
	    current_user.save!
	    respond_to do |format|
	    	if @response.save
	    		format.html { 
	    			flash[:success] = "Your Response was successfully made!"
	    			redirect_to edit_daily_challenge_path
	    		}
	    	end
	    end
	end

	def edit
		# puts @response.inspect
		@daily_challenge = WritingChallenge.daily
  		@writing_challenge_title = @daily_challenge.exercise
		@profile = Profile.find_by user_id: current_user.id
		
	end

	def update
		@response = Response.find(params[:id])
	  	if @response.update_attributes(response_params)
	  		@response.update(:time => Date.today, :wordcount => @response.response.split.size)
	  		flash[:success] = "Your Response was successfully updated!"
	    	redirect_to edit_daily_challenge_path
	  	else
	    	render "edit"
	  	end
	end

	private
	    def response_params
	    	params.require(:response).permit(:response, :prompt_id, :user, :time, :writer, :wordcount, :writing_challenge_id, :slug)
	    end

	    def daily_challenge

	    	@challenge = WritingChallenge.daily
	    	
			if request.fullpath.match(/daily-challenge/)
				puts 'enters'
				if current_user.present?
					@responses = current_user.responses
					@challenge = WritingChallenge.daily
					if @responses.present?
			    		puts "enters responses.present?"
			    		@responses.each do |response|
			    			puts "response.writing_challenge_id ", response.writing_challenge_id
			    			puts 'challenge id ', @challenge.id
			    			puts "writer is ", response.writer
			    			puts "current_user name is ", current_user.name
			    			puts "boolean value is ", response.writing_challenge_id == @challenge.id && response.writer == current_user.name
			    			puts " "
			    			if response.writing_challenge_id == @challenge.id && response.writer == current_user.name
			    				redirect_to edit_daily_challenge_path
			    			end
			    		end
			    	end
			    end
			else 
				@challenge = WritingChallenge.where("slug = ? ", params[:writing_challenge_title])
				@challenge = @challenge[0]
			end
	    end

	    def edit_daily_challenge
	    	if request.fullpath.match('/daily-challenge/edit')
	    		@challenge = WritingChallenge.daily
	    		@responses = current_user.responses
	    		@responses.each do |response|
	    			if response.writing_challenge_id == @challenge.id && response.writer == current_user.name
	    				@response = response
	    			end
	    		end
	    	else
	    		@challenge = WritingChallenge.where("slug = ? ", params[:writing_challenge_title])
				@challenge = @challenge[0]
				@responses = Response.where("slug = ? AND writer = ?", params[:writing_challenge_title], current_user.name)
				@responses.each do|res|
					@response = res
				end
	    	end
	    end

	    def daily_challenge_redirect
			if current_user
				@edit_daily_challenge = false
				@responses = current_user.responses
				@challenge = WritingChallenge.daily
				@responses.each do |response|
	    			if response.writing_challenge_id == @challenge.id
	    				@edit_daily_challenge = true
	    			end
	    		end
	    		if @edit_daily_challenge
	    			redirect_to edit_daily_challenge_path
	    		else
					redirect_to daily_challenge_path
				end
			end
		end

	    def auth_user
	    	@challenge = WritingChallenge.where("slug = ? ", params[:writing_challenge_title])
		    @response = Response.new(response_params)
		    @response.writing_challenge_id = @challenge[0].id
		    @response.slug = @challenge[0].slug
		    @response.time = Date.today
	    	@response.wordcount = @response.response.split.size
	    	@response.save!
	    	redirect_to new_user_registration_path unless user_signed_in?
	    end
end
