class AddNameInOrderAddress < ActiveRecord::Migration
  def up
    add_column :shoppe_order_addresses, :phone, :string
    add_column :shoppe_order_addresses, :receiver_name, :string
  end

  def down
    remove_column :shoppe_order_addresses, :phone, :string
    remove_column :shoppe_order_addresses, :receiver_name, :string
  end
end
