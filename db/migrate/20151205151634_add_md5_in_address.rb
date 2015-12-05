class AddMd5InAddress < ActiveRecord::Migration
  def up
    add_column :shoppe_addresses, :md5, :string
  end

  def down
    remove_column :shoppe_addresses, :md5
  end
end
