class AddActiveInVariant < ActiveRecord::Migration
  def change
    add_column :shoppe_variant_values, :active, :boolean, default: true
    add_column :shoppe_variant_types,  :active, :boolean, default: true
    add_column :shoppe_variant_types,  :position, :integer, default: 0
  end
end
