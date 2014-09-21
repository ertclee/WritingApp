class AddExerciseToWritingChallenge < ActiveRecord::Migration
  def change
    add_column :writing_challenges, :exercise, :string
  end
end
