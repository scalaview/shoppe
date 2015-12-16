module Shoppe
  class StockkeepingUnit < ActiveRecord::Base

    belongs_to :parent, :class_name => 'Shoppe::Product', :foreign_key => 'product_id'

    has_many   :product_variant_values, :class_name => 'Shoppe::ProductVariantValue', :foreign_key => 'stockkeeping_unit_id'

    has_many   :variant_values, :class_name => 'Shoppe::VariantValue' , :through => :product_variant_values

    has_many   :variant_types, :class_name => 'Shoppe::VariantType' , :through => :product_variant_values

    has_one    :product,   :class_name => 'Shoppe::Product', :foreign_key => 'product_id'

    # Is this product a variant of another?
    #
    # @return [Boolean]
    def variant?
      !self.parent_id.blank?
    end

    def add_variant(variant_value)
      add_variant!(variant_value)
    rescue Exception => e
      self.errors.add(:product_variant_values, e.message)
      logger.error e
      false
    end

    def add_variant!(variant_value)
      transaction do
        variant_value.variant_type
        self.product_variant_values.build({
            :variant_type_id => variant_value.variant_type.id,
            :variant_value_id => variant_value.id,
          }).save!
      end
    end

  end
end
