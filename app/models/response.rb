class Response < ActiveRecord::Base
	# validates :user_id, :uniqueness => { :scope => :writing_challenge_id, :message => "User may only write only one response per challenge."}
	belongs_to :writing_challenge
	belongs_to :user
	has_many :edits

	def compute_the_difference_score_between_two_strings(new_string)
		@new_string_array = new_string.split
		@old_string_array = self.response.split
		@difference_count = 0
		@original_word_count = 0
		@new_string_array.each_with_index do |new_word, index|
			if new_word != @old_string_array[index]
			    @difference_count += 1
			end
		end
		# This is to account for the deletion in the original response if the user is editing the response on a different date
		@old_string_array.each_with_index do |old_word, index|
			if @new_string_array[index].present?
				if @new_string_array[index] != old_word
					@original_word_count -= 1
				end
			end
		end
		[@difference_count, @original_word_count]
	end

	def compute_word_count_with_edits(difference_score_for_new_word, difference_score_for_old_word)
		self.wordcount += difference_score_for_old_word + difference_score_for_new_word
		self.wordcount
	end
end
