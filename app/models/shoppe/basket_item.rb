module Shoppe
  class BasketItem < ActiveRecord::Base

    belongs_to :customer, :class_name => "Shoppe::Customer"

    belongs_to :product, :class_name => "Shoppe::Product"

  end
end
