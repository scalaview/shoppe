class ChangeStatusString < ActiveRecord::Migration
  def change
    change_table :shoppe_orders do |t|
      t.change :status, :string, index: true, default: nil
    end
  end
end
