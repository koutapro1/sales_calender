class AddReferencesToSales < ActiveRecord::Migration[5.2]
  def change
    add_reference :sales, :user, null: false, foreign_key: true
  end
end
