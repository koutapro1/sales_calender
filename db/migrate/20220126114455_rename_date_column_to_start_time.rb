class RenameDateColumnToStartTime < ActiveRecord::Migration[5.2]
  def change
    rename_column :scores, :date, :start_time
  end
end
