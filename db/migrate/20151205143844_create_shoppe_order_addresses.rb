class CreateShoppeOrderAddresses < ActiveRecord::Migration
  def change
    create_table :shoppe_order_addresses do |t|
      t.string :address_type
      t.string :province
      t.string :city
      t.string :area
      t.string :street
      t.string :location
      t.string :postcode
      t.integer :country_id
      t.belongs_to :address, index: true
      t.string :md5

      t.timestamps
    end
  end
end
