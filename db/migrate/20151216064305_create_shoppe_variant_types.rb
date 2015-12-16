class CreateShoppeVariantTypes < ActiveRecord::Migration
  def change
    create_table :shoppe_variant_types do |t|
      t.string   :name
      t.timestamps
    end
  end
end
