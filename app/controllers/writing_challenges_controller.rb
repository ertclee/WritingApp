class WritingChallengesController < ApplicationController
	before_action :authenticate_user!, :except => [:index, :new, :create, :show]
	before_action :authenticate, :only => :new
	def index
		@challenges = WritingChallenge.paginate(:page => params[:page])#Kaminari.paginate_array(WritingChallenge.order(:created_at)).page(params[:page])
		if current_user
			@profile = Profile.find_by user_id: current_user.id
		end
		respond_to do |format|
      		format.html # index.html.erb
      		format.json { render json: @challenges }
      		format.js
      	end 
	end

	def new
		@challenge = WritingChallenge.new
	end

	def create
		@challenge = WritingChallenge.new(challenge_params)
		respond_to do |format|
			if @challenge.save
				format.html { redirect_to daily_challenge_path }
				format.json { render :show, status: :created, location: @challenge }
			else
				format.html { render :new }
				format.json { render json: @challenge.errors, status: :unprocessable_entity }
			end
		end
	end

	def show
		
	end
  
	def history
		if params[:date]
			@todays_date = params[:date].to_date
		else
			@todays_date = Date.today
		end
		@daily_challenge = WritingChallenge.daily
		@profile = Profile.find_by user_id: current_user.id
		@todays_date = Date.today
		@signup_date = current_user.created_at.localtime.strftime('%Y-%m-%d')
		@start_date = Date.new(@todays_date.cwyear, @todays_date.mon, BEGINNING_OF_THE_MONTH )
		@end_time = @start_date.to_date + 1.month
		@yy = Time.now.strftime('%g') # variable used for highcharts
		@total_of_month = 0
		@word_count_since_signup = 0
		@challenges = WritingChallenge.order(:created_at)
		daily_challenges = WritingChallenge.where("created_at >= ? AND created_at <= ?", @start_date.to_time, @end_time.to_time).order(:created_at)
		@daily_challenges = Hash.new(0)
		(@start_date.to_date..@end_time.to_date).each do |d|
			@daily_challenges["#{d.strftime('%d-%m-%Y')}"] = 0
		end
		@profile = Profile.find_by user_id: current_user.id
		current_user.target_goal = @profile.daily_goal # comment this line.
		@max_value_for_xAxis = days_in_month(Time.now.month) # variable used for highcharts.
		@localtime = []
		daily_challenges.each do |challenge| 
			if challenge && challenge.responses
				challenge.responses.each do |res|
					if res.writer == current_user.name
						@month = res.time.to_date.strftime('%-m')
						@day = res.time.to_date.strftime('%d')
						@exact_time = res.updated_at.in_time_zone(cookies["browser.timezone"])
						@localtime.push(@exact_time.localtime.strftime('%H:%M'))
						Date::MONTHNAMES[@month.to_i]
						@daily_challenges["#{res.time.to_date.strftime('%d-%m-%Y')}"] += res.response.split.size
					end
				end
			end
		end
		@daily_challenges.values.each do |val|
			@total_of_month += val
		end

		if Time.parse(@signup_date) < @start_date
			all_previous_challenges = current_user.writing_challenges.where("created_at >= ? AND created_at <= ?", @signup_date.to_time, @start_date.to_time).order(:created_at)
			all_previous_challenges.each do |challenge|
				challenge.responses.each do |res|
					@word_count_since_signup += res.response.split.size
				end
			end
		else 
			@word_count_since_signup = @total_of_month
		end
		@daily_challenges = @daily_challenges.map {|k,v| [k,v]}
		
		Kaminari.paginate_array(current_user.writing_challenges.order(:created_at)).page(params[:page])
		respond_to do |format|
		  format.html # index.html.erb
		  format.json { render json: @challenges }
		  format.js
		end 
	end
	
	private
	def challenge_params
  		params.require(:writing_challenge).permit(:exercise)
	end

	COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    BEGINNING_OF_THE_MONTH = 1
	def days_in_month(month, year = Time.now.year)
	   return 29 if month == 2 && Date.gregorian_leap?(year)
	   COMMON_YEAR_DAYS_IN_MONTH[month]
	end

	protected
	def authenticate
		authenticate_or_request_with_http_basic do |username, password|
			username == "admin" && password == "writersmob2014"
		end
	end
end
