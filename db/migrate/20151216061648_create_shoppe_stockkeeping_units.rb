class CreateShoppeStockkeepingUnits < ActiveRecord::Migration
  def change
    create_table :shoppe_stockkeeping_units do |t|
      t.string    :product_id,    null: false
      t.string    :sku
      t.boolean   :active,        default: true
      t.boolean   :stock_control, default: true
      t.decimal   :weight,        precision: 8, scale: 3, default: 0.0
      t.decimal   :cost_price,    precision: 8, scale: 3, default: 0.0
      t.decimal   :price,         precision: 8, scale: 3, default: 0.0
      t.integer   :tax_rate_id
      t.datetime  :deleted_at

      t.timestamps
    end

    add_index :shoppe_stockkeeping_units, :product_id
    add_index :shoppe_stockkeeping_units, :deleted_at
    add_index :shoppe_stockkeeping_units, :active
    add_index :shoppe_stockkeeping_units, :stock_control

    change_table :shoppe_products do |t|
      t.column :default_stockkeeping_unit_id, :integer
    end
    add_index :shoppe_products, :default_stockkeeping_unit_id

  end
end
