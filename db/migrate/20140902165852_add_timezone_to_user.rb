class AddTimezoneToUser < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string
    add_column :users, :target_goal, :integer
  end
end
