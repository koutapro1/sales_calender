class CreateScoreDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :score_details do |t|
      t.text       :coords,           null: false, array: true
      t.string     :pickup_address,   null: false
      t.string     :dropoff_address,  null: false
      t.datetime   :pickup_time,      null: false
      t.datetime   :dropoff_time,     null: false
      t.integer    :fare,             null: false
      t.references :score,            null: false, foreign_key: true

      t.timestamps
    end
  end
end
