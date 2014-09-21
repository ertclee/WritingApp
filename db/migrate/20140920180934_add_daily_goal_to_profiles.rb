class AddDailyGoalToProfiles < ActiveRecord::Migration
  def change
  	add_column :profiles, :daily_goal, :integer
  end
end
