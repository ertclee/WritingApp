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

	def history    
		@current_date = Date.today
		@start_date = Date.new(@todays_date.cwyear, @todays_date.mon, 1)
		@signup_month_year = current_user.created_at.localtime.strftime("%B '%y")
		@this_month = @start_date.strftime("%B '%y")
		@challenges = current_user.writing_challenges
		@max_value_for_xAxis = Time.days_in_month(@todays_date.mon)
		@challenges_this_month_hash = current_user.words_by_day(@start_date)
		puts "challenges_this_month_hash is ", current_user.words_by_day(@start_date)
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
  		params.require(:writing_challenge).permit(:exercise)
	end

	COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

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
