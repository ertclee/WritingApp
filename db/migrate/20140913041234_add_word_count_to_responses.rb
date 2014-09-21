class AddWordCountToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :wordcount, :string
  end
end
