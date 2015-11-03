module Shoppe
  class BasketItem < ActiveRecord::Base

    belongs_to :customer, :class_name => "Shoppe::Customer"

    belongs_to :product, :class_name => "Shoppe::Product"


    def self.add_item(ordered_item, quantity = 1)
      raise Errors::UnorderableItem, :ordered_item => ordered_item unless ordered_item.orderable?
      transaction do
        if existing = self.where(:product_id => ordered_item.id).first
          existing.increase!(quantity)
          existing
        else
          new_item = self.create(:product_id => ordered_item, :quantity => 0)
          new_item.increase!(quantity)
          new_item
        end
      end
    end

  end
end
