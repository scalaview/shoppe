module Shoppe
  class OrderAddress < ActiveRecord::Base
    self.table_name = 'shoppe_order_addresses'

    belongs_to :customer, :class_name => "Shoppe::Customer"
    belongs_to :address, :class_name => "Shoppe::Address"
    belongs_to :country, :class_name => "Shoppe::Country"
    has_one    :order,   :class_name => "Shoppe::Order"

    require_dependency 'shoppe/address/md5'

  end
end
