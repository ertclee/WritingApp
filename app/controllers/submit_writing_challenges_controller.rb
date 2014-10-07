class SubmitWritingChallengesController < ApplicationController
	def new 
		@mail = SubmitWritingChallenge.new
	end

	def create
		@mail = SubmitWritingChallenge.new(mailer_params)
		respond_to do |format|
			if @mail.save
				SubmitWritingChallengeMailer.submission_email(@mail).deliver
				format.html { redirect_to daily_challenge_path }
			end
		end
	end

	private
	def mailer_params
		params.require(:submit_writing_challenge).permit(:exercise, :user_id, :email)
	end
end
