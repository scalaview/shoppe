class ChangeStatus < ActiveRecord::Migration
  def change
    change_table :shoppe_orders do |t|
      t.change :status, :integer, null: false, index: true, default: 0
    end
  end
end
