module Shoppe
  class ProductVariantValue < ActiveRecord::Base

    belongs_to :stockkeeping_unit, :class_name => 'Shoppe::StockkeepingUnit'

    belongs_to :variant_type, :class_name => 'Shoppe::VariantType', touch: true

    belongs_to :variant_value, :class_name => 'Shoppe::VariantValue'

    validates_uniqueness_of :stockkeeping_unit_id, :scope => [:variant_value_id, :variant_type_id]

    before_save do
      variant_value.present? && (variant_type_id = variant_value.variant_type_id)
    end

  end
end
