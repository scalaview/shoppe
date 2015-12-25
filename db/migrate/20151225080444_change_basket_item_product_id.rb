class ChangeBasketItemProductId < ActiveRecord::Migration
  def change
    change_table :shoppe_basket_items do |t|
      t.rename :product_id, :stockkeeping_unit_id
    end
  end
end
