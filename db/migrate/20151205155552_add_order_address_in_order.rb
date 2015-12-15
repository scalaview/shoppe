class AddOrderAddressInOrder < ActiveRecord::Migration
  def up
    add_column :shoppe_orders, :delivery_address_id, :integer
    add_column :shoppe_orders, :billing_address_id, :integer
  end

  def down
    remove_column :shoppe_orders, :delivery_address_id
    remove_column :shoppe_orders, :billing_address_id
  end
end
