class Response < ActiveRecord::Base
	# validates :user_id, :uniqueness => { :scope => :writing_challenge_id, :message => "User may only write only one response per challenge."}
	belongs_to :writing_challenge
	belongs_to :user
	has_many :edits

	def compute_the_difference_score_between_two_strings(new_string)
    deletion = 0
    first = self.response.split
    second = new_string.split
    first_size = first.size
    second_size = second.size
    matrix = [(0..first_size).to_a]
    (1..second_size ).each do |j|
      matrix << [j] + [0] * (first_size)
    end
    count = 0
    (1..second_size).each do |i|
      (1..first_size).each do |j|
        if first[j-1] == second[i-1]
          matrix[i][j] = matrix[i-1][j-1]
        else
          matrix[i][j] = [matrix[i-1][j],matrix[i][j-1], matrix[i-1][j-1]].min + 1
        end
      end
    end
    return matrix.last.last 
	end

	def compute_word_count_with_edits(difference_score_for_new_word, difference_score_for_old_word)
		self.wordcount += difference_score_for_old_word + difference_score_for_new_word
		self.wordcount
	end
end
