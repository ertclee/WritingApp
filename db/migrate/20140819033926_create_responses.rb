class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :writer
      t.text :response
      t.references :writing_challenge, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
