class AddUniqueIndexToScore < ActiveRecord::Migration[5.2]
  def change
    add_index :scores, %i[start_time user_id], unique: true
  end
end
