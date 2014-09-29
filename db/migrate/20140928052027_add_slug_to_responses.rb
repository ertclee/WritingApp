class AddSlugToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :slug, :string
    add_index :responses, :slug
  end
end
