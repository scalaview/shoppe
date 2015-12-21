module Shoppe
  class ProductVariantType < ActiveRecord::Base

    belongs_to :product, :class_name => 'Shoppe::Product'

    belongs_to :variant_type, :class_name => 'Shoppe::VariantType', touch: true

    validates_uniqueness_of :product_id, :scope => :variant_type_id

  end
end
