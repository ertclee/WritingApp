class CreateWritingChallenges < ActiveRecord::Migration
  def change
    create_table :writing_challenges do |t|

      t.timestamps
    end
  end
end
