class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.date       :work_on, null: false
      t.integer    :shift,   null: false
      t.references :user,    null: false, foreign_key: true

      t.timestamps

      t.index %i[work_on user_id], unique: true
    end
  end
end
