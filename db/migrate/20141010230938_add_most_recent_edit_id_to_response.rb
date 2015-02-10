class AddMostRecentEditIdToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :edit_id, :integer
  end
end
