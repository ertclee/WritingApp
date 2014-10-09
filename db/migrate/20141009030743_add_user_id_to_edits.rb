class AddUserIdToEdits < ActiveRecord::Migration
  def change
  	add_column :edits, :user_id, :integer
  end
end
