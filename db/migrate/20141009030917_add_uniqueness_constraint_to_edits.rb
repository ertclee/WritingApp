class AddUniquenessConstraintToEdits < ActiveRecord::Migration
  add_index  :edits, [:user_id, :response_id], :unique => true
end
