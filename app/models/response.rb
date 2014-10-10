class Response < ActiveRecord::Base
	# validates :user_id, :uniqueness => { :scope => :writing_challenge_id, :message => "User may only write only one response per challenge."}
	belongs_to :writing_challenge
	belongs_to :user
	has_many :edits

	def compute_the_difference_score_between_two_strings(new_string)
	  oldstringarr = self.response.split
	  newstringarr = new_string.split
    m = newstringarr.length
    n = oldstringarr.length
    return m if n == 0
    return n if m == 0
    d = Array.new(m+1) {Array.new(n+1)}
  
    (0..m).each {|i| d[i][0] = i}
    (0..n).each {|j| d[0][j] = j}
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if oldstringarr[i-1] == newstringarr[j-1]  # adjust index into string
                    d[i-1][j-1]       # no operation required
                  else
                    [ d[i-1][j]+1,    # deletion
                      d[i][j-1]+1,    # insertion
                      d[i-1][j-1]+1,  # substitution
                    ].min
                  end
      end
    end
    d[m][n]
	end

	def compute_word_count_with_edits(difference_score_for_new_word, difference_score_for_old_word)
		self.wordcount += difference_score_for_old_word + difference_score_for_new_word
		self.wordcount
	end
end
