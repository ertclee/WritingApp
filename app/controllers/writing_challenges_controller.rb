class WritingChallengesController < ApplicationController
	before_action :authenticate_user!, :except => [:index, :new, :create, :show]
	before_action :authenticate_admin, :only => :new
	before_action :set_todays_date, :only => :history

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

	# def history
	# 	# get the responses with the most & least word count
	# 	@daily_challenge = WritingChallenge.daily
	# 	@signup_month_year = current_user.created_at.localtime.strftime("%B '%y")
	# 	@profile = Profile.find_by user_id: current_user.id
	# 	@signup_date = current_user.created_at.localtime.strftime('%Y-%m-%d')
	# 	@start_date = Date.new(@todays_date.cwyear, @todays_date.mon, BEGINNING_OF_THE_MONTH )
	# 	@end_time = @start_date.to_date + 1.month
	# 	@yy = Time.now.strftime('%g') # variable used for highcharts
	# 	@total_of_month = 0
	# 	@word_count_since_signup = 0
	# 	@challenges = WritingChallenge.order(:created_at)
	# 	@challenges_this_month = WritingChallenge.where("created_at >= ? AND created_at <= ?", @start_date.to_time, @end_time.to_time).order(:created_at)
	# 	@challenges_this_month_hash = Hash.new(0)
	# 	(@start_date.to_date..@end_time.to_date).each do |d|
	# 		@challenges_this_month_hash["#{d.strftime('%d-%m-%Y')}"] = 0
	# 	end
	# 	@profile = Profile.find_by user_id: current_user.id
	# 	current_user.target_goal = @profile.daily_goal # comment this line.
	# 	@max_value_for_xAxis = days_in_month(Time.now.month) # variable used for highcharts.
	# 	@localtime = Hash.new
	# 	@challenges_this_month.each do |challenge| 
	# 		if challenge && challenge.responses
	# 			challenge.responses.each do |res|
	# 				if res.writer == current_user.name
	# 					@month = res.time.to_date.strftime('%-m')
	# 					@day = res.time.to_date.strftime('%d')
	# 					@exact_time = res.updated_at.in_time_zone(cookies["browser.timezone"])
	# 					# puts 'response is ', res.inspect
	# 					# puts 'response updated at ', res.updated_at.in_time_zone(cookies["browser.timezone"])
	# 					@localtime[res.slug] = @exact_time.localtime.strftime('%H:%M')
	# 					# puts "this is my size: ", res.response.split.size
	# 					@challenges_this_month_hash["#{res.time.to_date.strftime('%d-%m-%Y')}"] += res.response.split.size
	# 				end
	# 			end
	# 		end
	# 	end
	# 	@challenges_this_month_hash.values.each do |val|
	# 		@total_of_month += val
	# 	end

	# 	# puts "time parsed for signup date is ", Time.parse(@signup_date)
	# 	# puts "start date is ", @start_date
	# 	# puts "boolean value is ", Time.parse(@signup_date) < @start_date


	# 	@word_count_for_previous_months = Hash.new(0)
	

	# 	if Time.parse(@signup_date) < @start_date
	# 		@signup_date = @signup_date.to_date
	# 		@beginning_of_previous_month = Date.new(@signup_date.cwyear, @signup_date.mon, BEGINNING_OF_THE_MONTH )
	# 		(@beginning_of_previous_month..@start_date.to_date).each do |d|
	# 			@word_count_for_previous_months["#{d.strftime('%d-%m-%Y')}"] = 0
	# 		end
	# 		all_previous_challenges = WritingChallenge.where("created_at >= ? AND created_at < ?", @signup_date.to_time, @start_date).order(:created_at)
	# 		all_previous_challenges.each do |challenge|
	# 			if challenge && challenge.responses
	# 				challenge.responses.each do |res|
	# 					if res.writer == current_user.name
	# 						@month = res.time.to_date.strftime('%-m')
	# 						@day = res.time.to_date.strftime('%d')
	# 						@exact_time = res.updated_at.in_time_zone(cookies["browser.timezone"])
	# 						# puts 'response is ', res.inspect
	# 						# puts 'response updated at ', res.updated_at.in_time_zone(cookies["browser.timezone"])
	# 						@localtime[res.slug] = @exact_time.localtime.strftime('%H:%M')
	# 						@word_count_since_signup += res.response.split.size
	# 						@word_count_for_previous_months["#{res.time.to_date.strftime('%d-%m-%Y')}"] += res.response.split.size
	# 					end
	# 				end
	# 			end
	# 		end
	# 		@word_count_since_signup += @total_of_month
	# 	else 
	# 		@word_count_since_signup = @total_of_month
	# 	end

	# 	@date_for_history = params[:date]

	# 	if @date_for_history
	# 		@challenges_this_month_hash = @word_count_for_previous_months
	# 	end


	# 	@challenges_this_month_hash = @challenges_this_month_hash.map {|k,v| [k,v]}
	# 	puts "challenges this month is ", @challenges_this_month_hash
	# 	@all_responses_to_writing_challenges = Response.where('user = ?', current_user.name)
	# 	#@paginated_arrays = Kaminari.paginate_array(@all_responses_to_writing_challenges).page(params[:page])
	# 	# respond_to do |format|
	# 	#   format.html # index.html.erb
	# 	#   format.json { render json: @word_count_for_previous_months}
	# 	#   format.js
	# 	# end 
	# end

	def history    
		@current_date = Date.today
		@start_date = Date.new(@todays_date.cwyear, @todays_date.mon, 1)
		@signup_month_year = current_user.created_at.localtime.strftime("%B '%y")
		@this_month = @start_date.strftime("%B '%y")
		@challenges = current_user.writing_challenges
		@max_value_for_xAxis = Time.days_in_month(@todays_date.mon)
		@challenges_this_month_hash = current_user.words_by_day(@start_date)
		@challenges_this_month_hash = @challenges_this_month_hash.map {|k,v| [k,v]}
		@max_value_for_yaxis = current_user.max_value_for_yaxis 
		@profile = Profile.find_by user_id: current_user.id
		@max_value_for_yaxis = if @max_value_for_yaxis.to_i > @profile.daily_goal.to_i then @max_value_for_yaxis.to_i else @profile.daily_goal.to_i end
		@max_value_for_yaxis += 10
	end

	
	def about
		render 'about.html.erb'
	end

	private

	def challenge_params
  		params.require(:writing_challenge).permit(:exercise, :user_id)
	end

	COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    BEGINNING_OF_THE_MONTH = 1
	def days_in_month(month, year = Time.now.year)
	   return 29 if month == 2 && Date.gregorian_leap?(year)
	   COMMON_YEAR_DAYS_IN_MONTH[month]
	end

	def set_todays_date
		if params[:date]
			@todays_date = params[:date].to_date
		else
			@todays_date = Date.today
		end
	end

	def authenticate_admin
		authenticate_or_request_with_http_basic do |username, password|
			username == "admin" && password == "writersmob2014"
		end
	end
end
