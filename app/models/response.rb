class Response < ActiveRecord::Base
	# validates :user_id, :uniqueness => { :scope => :writing_challenge_id, :message => "User may only write only one response per challenge."}
	belongs_to :writing_challenge
	belongs_to :user
	has_many :edits

	def edits
	  @edits = Edit.where("response_id = ? ", self.id)
	  return @edits
	end
	
#	def find_latest_edits
#	  @edits = self.my_edits
#	  puts @edits
#	  if @edits = nil?
##	    return self.time
#	  end
#	  @sorted = @edits.sort { |x,y| x.time <=> y.time }
#	  return @sorted[0].time
#	end
	
	#REFACTOR
	def edits_on_same_day
	  @edits = []
	  @alledits = Edit.all
	  @alledits.each do |edit|
	    print edit.inspect
	    if edit.time != nil
  	    if edit.time.strftime('%d-%m-%Y') == self.time.strftime('%d-%m-%Y')
  	      @edits.push(edit)
  	    end
  	  end
	  end
	  @edits
	end
	
end
