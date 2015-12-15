module Shoppe
  class PaymentMethod < ActiveRecord::Base

    validates :name, :presence => true
    validates :code, :presence => true

    scope :all_display, -> { where(:display => true) }
    scope :default_sort, -> { order(["sort_num DESC", "id DESC"]) }

    METHODS = all_display.inject({}) do |m, pm|
      k = pm.code.strip.downcase.gsub(/\s+/, '_').to_sym
      m[k] = pm.id
      m
    end

  end
end
