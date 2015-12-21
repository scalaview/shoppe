module Shoppe
  class VariantType < ActiveRecord::Base

    has_many :variant_values, :class_name => 'Shoppe::VariantValue'

    has_many :product_variant_values, :class_name => 'Shoppe::ProductVariantValue'

    has_many :product_variant_types, :class_name => 'Shoppe::ProductVariantType'

    has_many :products, :class_name => 'Shoppe::Product', :through => :product_variant_types

    scope :active, -> { where(active: true)}

  end
end
