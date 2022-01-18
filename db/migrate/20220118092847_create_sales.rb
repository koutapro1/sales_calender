class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.integer :sales
      t.text :memo
      t.datetime :date

      t.timestamps
    end
  end
end
