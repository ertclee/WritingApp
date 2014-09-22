class WritingChallenge < ActiveRecord::Base
	has_many :responses
	belongs_to :user
	self.per_page = 20

	def self.daily
		WritingChallenge.last
	end
end
