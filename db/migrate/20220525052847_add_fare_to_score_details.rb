class AddFareToScoreDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :score_details, :fare, :integer, null: false, default: 0
  end
end
