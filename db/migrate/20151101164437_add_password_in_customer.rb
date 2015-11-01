class AddPasswordInCustomer < ActiveRecord::Migration
  def up
    add_column :shoppe_customers, :password_digest, :string
    add_column :shoppe_customers, :wxid, :string
  end

  def down
    remove_column :shoppe_customers, :password_digest
    remove_column :shoppe_customers, :wxid
  end
end
