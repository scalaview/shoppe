module Shoppe
  class VariantType < ActiveRecord::Base

    has_many :variant_values, :class_name => 'Shoppe::VariantValue'

    has_many :product_variant_values, :class_name => 'Shoppe::ProductVariantValue'

  end
end
