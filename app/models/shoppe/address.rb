module Shoppe
  class Address < ActiveRecord::Base

    # An array of all the available types for an address
    TYPES = {
      billing: "billing",
      delivery: "delivery"
    }

    # Set the table name
    self.table_name = "shoppe_addresses"

    require_dependency 'shoppe/address/md5'

    # The customer which this address should be linked to
    #
    # @return [Shoppe::Customer]
    belongs_to :customer, :class_name => "Shoppe::Customer"

    # The order which this address should be linked to
    #
    # @return [Shoppe::Order]
    belongs_to :order, :class_name => "Shoppe::Order"

    # The country which this address should be linked to
    #
    # @return [Shoppe::Country]
    belongs_to :country, :class_name => "Shoppe::Country"

    has_many   :order_addresses, :class_name => "Shoppe::OrderAddress"

    # Validations
    validates :address_type, :presence => true, :inclusion => {:in => TYPES.values}
    validates :province, :presence => true
    validates :city, :presence => true
    validates :area, :presence => true
    validates :street, :presence => true
    validates :postcode, :presence => true
    validates :country, :presence => true

    # All addresses ordered by their id asending
    scope :ordered, -> { order(:id => :desc)}
    scope :default_first, -> { order(:default => :desc).ordered}
    scope :default, -> { where(default: true)}
    scope :billing, -> { where(address_type: "billing")}
    scope :delivery, -> { where(address_type: "delivery")}

    def full_address
      [address1, address2, address3, address4, postcode, country.try(:name)].join(", ")
    end

    def generate_order_address(order, type)
      generate_order_address!(order, type)
    rescue Exception => e
      logger.error e.message
      false
    end

    def generate_order_address!(order, type)
      transaction do
        order_address = self.order_addresses.create({
            :country_id => self.country_id,
            :address_type => type,
            :province => self.province,
            :city => self.city,
            :area => self.area,
            :street => self.street,
            :location => self.location,
            :postcode => self.postcode,
            :country_id => self.country_id
          })
        order["#{type}_address_id"] = order_addresses
        order.save!
      end
    end

  end
end
