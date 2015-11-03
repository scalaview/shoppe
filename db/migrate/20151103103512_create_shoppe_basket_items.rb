class CreateShoppeBasketItems < ActiveRecord::Migration
  def change
    create_table :shoppe_basket_items do |t|
      t.integer :customer_id, null: false, index: true
      t.integer :product_id, null: false, index: true
      t.integer :quantity, default: 0
      t.timestamps
    end
  end
end
