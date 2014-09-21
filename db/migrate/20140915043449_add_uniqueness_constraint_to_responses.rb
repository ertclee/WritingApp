class AddUniquenessConstraintToResponses < ActiveRecord::Migration
  add_index  :responses, [:user_id, :writing_challenge_id], :unique => true
end
