module Shoppe
  class BasketItem < ActiveRecord::Base

    belongs_to :customer, :class_name => "Shoppe::Customer"

    belongs_to :product, :class_name => "Shoppe::Product"

    has_many :stock_level_adjustments, :as => :parent, :dependent => :nullify, :class_name => 'Shoppe::StockLevelAdjustment'

    def increase(amount = 1)
      increase!(amount)
    rescue Exception => e
      logger.error e.message
      self.errors.add(:quantity, e.message)
      false
    end

    def increase!(amount = 1)
      transaction do
        self.quantity += amount
        unless self.in_stock?
          raise Shoppe::Errors::NotEnoughStock, :ordered_item => self.product, :requested_stock => self.quantity,
            :message => "only #{self.product.stock} in stock, requested : #{self.quantity}, not enough"
        end
        self.save!
      end
    end

    def decrease(amount = 1)
      decrease!(amount)
    rescue
      false
    end

    def decrease!(amount = 1)
      transaction do
        self.quantity -= amount
        self.quantity == 0 ? self.destroy : self.save!
      end
    end

    def update_quantity(quantity = 1)
      update_quantity!(quantity)
    rescue Exception => e
      logger.error e.message
      self.errors.add(:quantity, e.message)
      false
    end

    def update_quantity!(quantity = 1)
      transaction do
        self.quantity = quantity
        unless self.in_stock?
          raise Shoppe::Errors::NotEnoughStock, :ordered_item => self.product, :requested_stock => self.quantity,
            :message => "only #{self.product.stock} in stock, requested : #{self.quantity}, not enough"
        end
        self.quantity == 0 ? self.destroy : self.save!
      end
    end

    def in_stock?
      if self.product && self.product.stock_control?
        self.product.stock >= unallocated_stock
      else
        true
      end
    end

    def unallocated_stock
      self.quantity - allocated_stock
    end

    def allocated_stock
      0 - self.stock_level_adjustments.sum(:adjustment)
    end

    class << self

      def add_item(ordered_item, quantity = 1)
        raise Errors::UnorderableItem, :ordered_item => ordered_item unless ordered_item.orderable?
        transaction do
          if existing = self.where(:product => ordered_item.id).first
            existing.increase(quantity)
            existing
          else
            new_item = self.create(:product => ordered_item, :quantity => 0)
            new_item.increase(quantity)
            new_item
          end
        end
      end

    end

  end
end
