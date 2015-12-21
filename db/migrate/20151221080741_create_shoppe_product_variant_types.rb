class CreateShoppeProductVariantTypes < ActiveRecord::Migration
  def change
    create_table :shoppe_product_variant_types do |t|
      t.integer  :product_id, null: false
      t.integer  :variant_type_id, null: false

      t.timestamps
    end
  end
end
