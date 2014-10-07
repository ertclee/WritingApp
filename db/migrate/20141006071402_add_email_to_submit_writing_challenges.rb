class AddEmailToSubmitWritingChallenges < ActiveRecord::Migration
  def change
  	add_column  :submit_writing_challenges, :email, :string
  end
end
