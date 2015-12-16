module Shoppe
  class VariantType < ActiveRecord::Base

    has_many :variant_values, :class_name => 'Shoppe::VariantValue'

  end
end