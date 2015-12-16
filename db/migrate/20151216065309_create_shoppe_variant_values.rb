class CreateShoppeVariantValues < ActiveRecord::Migration
  def change
    create_table :shoppe_variant_values do |t|
      t.integer :variant_type_id
      t.string  :name
      t.integer :position,  default: 0

      t.timestamps
    end

    add_index :shoppe_variant_values, :variant_type_id
    add_index :shoppe_variant_values, :position

  end
end
