class AddTimeToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :time, :date
  end
end
