class CreateEdits < ActiveRecord::Migration
  def change
    create_table :edits do |t|
      t.timestamps
    end
  end
end
