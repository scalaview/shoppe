class AddnameInaddress < ActiveRecord::Migration
  def up
    add_column :shoppe_addresses, :phone, :string
    add_column :shoppe_addresses, :receiver_name, :string
  end

  def down
    remove_column :shoppe_addresses, :phone, :string
    remove_column :shoppe_addresses, :receiver_name, :string
  end
end
