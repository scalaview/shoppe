module Shoppe
  class VariantValue < ActiveRecord::Base

    belongs_to :variant_type, :class_name => 'Shoppe::VariantType', touch: true

    has_many   :product_variant_values, :class_name => 'Shoppe::ProductVariantValue'

  end
end
