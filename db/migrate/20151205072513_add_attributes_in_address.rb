class AddAttributesInAddress < ActiveRecord::Migration
  def change
    change_table :shoppe_addresses do |t|
      t.column :province, :string, null: true, index: true
      t.column :city, :string, null: true, index: true
      t.column :area, :string, null: true, index: true
      t.column :street, :string, null: true, index: true
    end

  end
end
