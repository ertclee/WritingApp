class AddResponseIdToEdit < ActiveRecord::Migration
  def change
    add_column :edits, :response_id, :integer
  end
end
