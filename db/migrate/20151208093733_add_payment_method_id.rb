class AddPaymentMethodId < ActiveRecord::Migration
  def up
    add_column :shoppe_orders, :payment_method_id, :integer, index: true

  end

  def down
    remove_column :shoppe_orders, :payment_method_id
  end
end
