class AddAncestryToCatrigratry < ActiveRecord::Migration
  def change
    add_column :shoppe_product_categories, :ancestry, :string
    add_index :shoppe_product_categories, :ancestry
  end
end
