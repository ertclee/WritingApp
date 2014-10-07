class AddTimeToEdits < ActiveRecord::Migration
  def change
    add_column :edits, :time, :datetime
  end
end
