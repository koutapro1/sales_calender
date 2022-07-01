class AddDefaultToScore < ActiveRecord::Migration[6.1]
  def up
    change_column :scores, :score, :integer, default: 0
  end
end
