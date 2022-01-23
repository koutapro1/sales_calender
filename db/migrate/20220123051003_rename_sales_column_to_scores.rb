class RenameSalesColumnToScores < ActiveRecord::Migration[5.2]
  def change
    rename_column :scores, :sales, :score
  end
end
