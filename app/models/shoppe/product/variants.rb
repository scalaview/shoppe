module Shoppe
  class Product < ActiveRecord::Base

    # Validations
    validate { errors.add :base, :can_belong_to_root if self.parent && self.parent.parent }

    # Variants of the product
    has_many :variants, :class_name => 'Shoppe::StockkeepingUnit', :foreign_key => 'product_id', :dependent => :destroy

    has_many :product_variant_types, :class_name => 'Shoppe::ProductVariantType'

    has_many :variant_types, :class_name => 'Shoppe::VariantType', :through => :product_variant_types

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

    def variant_values(variant_type=nil)
      Rails.cache.fetch("variant_values#{self.id}#{ variant_type.present? ? (variant_type.id.to_s + variant_type.updated_at.to_i.to_s) : '' }", expires_in: 2.weeks) do
        scope = VariantValue.joins(:product_variant_values)
                    .where("stockkeeping_unit_id in (?)", variants.pluck(:id))
        scope = scope.where("shoppe_product_variant_values.variant_type_id = ? ", variant_type.id)  if variant_type.present?
        scope.order(:position).uniq.to_a
      end
    end

  end
end
