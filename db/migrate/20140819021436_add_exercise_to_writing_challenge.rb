class AddExerciseToWritingChallenge < ActiveRecord::Migration
  def change
    add_column :writing_challenges, :exercise, :string
    add_index :writing_challenges, :exercise
  end
end
