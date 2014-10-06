class CreateSubmitWritingChallenges < ActiveRecord::Migration
  def change
    create_table :submit_writing_challenges do |t|

      t.timestamps
    end
  end
end
