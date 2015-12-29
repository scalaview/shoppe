class RemoveCloumnCatrigratry < ActiveRecord::Migration
  def change
    remove_column :shoppe_product_categories, :parent_id
    remove_column :shoppe_product_categories, :lft
    remove_column :shoppe_product_categories, :rgt
  end
end
