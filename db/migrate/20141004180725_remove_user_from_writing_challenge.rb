class RemoveUserFromWritingChallenge < ActiveRecord::Migration
  def change
    remove_column :writing_challenges, :user_id
  end
end
