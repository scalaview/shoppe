class CreateShoppeRegion < ActiveRecord::Migration
  def change
    create_table :shoppe_regions do |t|
      t.integer :code, null: false, index: true
      t.integer :parentcode, index: true
      t.string :name, null: false
      t.integer :level, null: false, index: true
      t.timestamps
    end
  end
end
