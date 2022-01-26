class ChangeDatatypeDateOfScores < ActiveRecord::Migration[5.2]
  def change
    change_column :scores, :date, :date
  end
end
