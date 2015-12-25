module Shoppe
  class StockLevelAdjustment < ActiveRecord::Base

    # The orderable item which the stock level adjustment belongs to
    belongs_to :item, :polymorphic => true

    # The parent (OrderItem) which the stock level adjustment belongs to
    belongs_to :parent, :polymorphic => true

    # Validations
    validates :description, :presence => true
    validates :adjustment, :numericality => true
    validate { errors.add(:adjustment, I18n.t('shoppe.activerecord.attributes.stock_level_adjustment.must_be_greater_or_equal_zero')) if adjustment == 0 }

    # All stock level adjustments ordered by their created date desending
    scope :ordered, -> { order(:id => :desc) }

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, :dependent => :destroy, :class_name => 'Shoppe::StockLevelAdjustment', :as => :item


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
