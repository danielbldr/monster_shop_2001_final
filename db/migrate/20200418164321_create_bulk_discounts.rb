class CreateBulkDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :bulk_discounts do |t|
      t.string :minimum_items
      t.integer :percentage_off
      t.string :description
      t.references :merchant, foreign_key: true
    end
  end
end
