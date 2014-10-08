class Response < ActiveRecord::Base
	# validates :user_id, :uniqueness => { :scope => :writing_challenge_id, :message => "User may only write only one response per challenge."}
	belongs_to :writing_challenge
	belongs_to :user
	has_many :edits

	def compute_the_difference_score_between_two_strings(new_string)
		@new_string_array = new_string.split
		@old_string_array = self.response.split
		@difference_count = 0
		@new_string_array.each_with_index do |new_word, index|
			if new_word != @old_string_array[index]
			    @difference_count += 1
			end
		end
		@difference_count
	end
end
