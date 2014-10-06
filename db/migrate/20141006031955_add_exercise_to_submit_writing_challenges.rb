class AddExerciseToSubmitWritingChallenges < ActiveRecord::Migration
  def change
  	add_column :submit_writing_challenges, :exercise, :string
    add_index :submit_writing_challenges, :exercise
  end
end
