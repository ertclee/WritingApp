class AddSlugToWritingChallenges < ActiveRecord::Migration
  def change
  	add_column :writing_challenges, :slug, :string
  	add_index :writing_challenges, :slug
  end
end
