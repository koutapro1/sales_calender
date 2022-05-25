class RemoveDefaultRestrictFromFare < ActiveRecord::Migration[6.1]
  def change
    change_column_default :score_details, :fare, from: 0, to: nil
  end
end
