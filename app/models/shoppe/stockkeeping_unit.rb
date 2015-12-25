module Shoppe
  class StockkeepingUnit < ActiveRecord::Base

    belongs_to :parent, :class_name => 'Shoppe::Product', :foreign_key => 'product_id'

    has_many   :product_variant_values, :class_name => 'Shoppe::ProductVariantValue', :foreign_key => 'stockkeeping_unit_id'

    has_many   :variant_values, :class_name => 'Shoppe::VariantValue' , :through => :product_variant_values

    has_many   :variant_types, :class_name => 'Shoppe::VariantType' , :through => :product_variant_values

    has_one    :product,   :class_name => 'Shoppe::Product', :foreign_key => 'default_stockkeeping_unit_id'

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, :dependent => :destroy, :class_name => 'Shoppe::StockLevelAdjustment', :as => :item

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
        unless self.parent.product_variant_types.where(:variant_type_id => variant_value.variant_type.id).present?
          self.parent.product_variant_types
              .build({ :product_id => self.parent.id, :variant_type_id => variant_value.variant_type.id })
              .save!
        end
        self.product_variant_values.build({
            :variant_type_id => variant_value.variant_type.id,
            :variant_value_id => variant_value.id,
          }).save!
      end
    end



    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      self.default_variant ? self.default_variant.in_stock? : (stock_control? ? stock > 0 : true)
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    def stock
      self.stock_level_adjustments.sum(:adjustment)
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless self.active?
      true
    end
  end
end
