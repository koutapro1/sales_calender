class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.integer :score, null: false
      t.datetime :start_time, null: false
      t.text :memo

      t.timestamps
    end
  end
end
