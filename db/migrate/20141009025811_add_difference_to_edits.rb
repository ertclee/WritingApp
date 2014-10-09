class AddDifferenceToEdits < ActiveRecord::Migration
  def change
  	add_column :edits, :difference, :integer
  end
end
