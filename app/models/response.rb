class Response < ActiveRecord::Base
	# validates :user_id, :uniqueness => { :scope => :writing_challenge_id, :message => "User may only write only one response per challenge."}
	belongs_to :writing_challenge
	belongs_to :user
	
end
