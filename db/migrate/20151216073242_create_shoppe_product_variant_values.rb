class CreateShoppeProductVariantValues < ActiveRecord::Migration
  def change
    create_table :shoppe_product_variant_values do |t|
      t.integer   :stockkeeping_unit_id, null: false
      t.integer   :variant_value_id, null: false
      t.integer   :variant_type_id, null: false

      t.timestamps
    end

    add_index :shoppe_product_variant_values, :stockkeeping_unit_id
    add_index :shoppe_product_variant_values, :variant_value_id
    add_index :shoppe_product_variant_values, :variant_type_id
  end
end
