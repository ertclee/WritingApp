class AddWordsToEdit < ActiveRecord::Migration
  def change
    add_column :edits, :words, :string
  end
end
