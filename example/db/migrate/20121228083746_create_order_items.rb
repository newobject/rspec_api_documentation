class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.string :name
      t.integer :amount
      t.references :order

      t.timestamps
    end
  end
end
