module Shoppe
  class Product < ActiveRecord::Base

    # Validations
    validate { errors.add :base, :can_belong_to_root if self.parent && self.parent.parent }

    # Variants of the product
    has_many :variants, :class_name => 'Shoppe::StockkeepingUnit', :foreign_key => 'product_id', :dependent => :destroy

    # The parent product (only applies to variants)
    belongs_to :parent, :class_name => 'Shoppe::Product', :foreign_key => 'parent_id'

    belongs_to :stockkeeping_unit, :class_name =>  'Shoppe::StockkeepingUnit', :foreign_key => 'default_stockkeeping_unit_id'

    delegate *%w{sku stock_control weight cost_price price tax_rate_id tax_rate}, to: :stockkeeping_unit, allow_nil: true

    # Does this product have any variants?
    #
    # @return [Boolean]
    def has_variants?
      variants.size > 1
    end

    # Returns the default variant for the product or nil if none exists.
    #
    # @return [Shoppe::Product]
    def default_variant
      return nil if !has_variants?
      @default_variant ||= self.stockkeeping_unit
    end

    def stockkeeping_unit=(attrs)
      if self.stockkeeping_unit.blank?
        self.create_stockkeeping_unit attrs.merge(:product_id => self.id)
      else
        stockkeeping_unit.update_attributes attrs
      end
    end

    def variant_types
      VariantType.joins(:product_variant_values)
                 .where("stockkeeping_unit_id in (?)", variants.pluck(:id))
                 .order(:position).uniq
    end

  end
end
