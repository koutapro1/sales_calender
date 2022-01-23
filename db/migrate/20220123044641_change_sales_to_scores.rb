class ChangeSalesToScores < ActiveRecord::Migration[5.2]
  def change
    rename_table :sales, :scores
  end
end
