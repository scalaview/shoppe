class AddLocationInAddress < ActiveRecord::Migration
  def change
     add_column :shoppe_addresses, :location, :string
  end
end
