class AddColumnUserIdToWrittingChallenge < ActiveRecord::Migration
  def change
    add_column :writing_challenges, :user_id, :integer
  end
end
