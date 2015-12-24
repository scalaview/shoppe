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
    #validates :address_type, :presence => true, :inclusion => {:in => TYPES.values}
    validates :receiver_name, :presence => true
    validates :phone, :presence => true
    validates :province, :presence => true
    validates :city, :presence => true
    validates :area, :presence => true
    validates :location, :presence => true
    #validates :street, :presence => true
    validates :postcode, :presence => true
    validates :country, :presence => true

    # All addresses ordered by their id asending
    scope :ordered, -> { order(:id => :desc)}
    scope :default_first, -> { order(:default => :desc).ordered}
    scope :default, -> { where(default: true).last}
    scope :billing, -> { where(address_type: "billing").last}
    scope :delivery, -> { where(address_type: "delivery").last}


    before_save :reset_default

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
        order_address = self.order_addresses.create!({
            :country_id => self.country_id,
            :phone => self.phone,
            :receiver_name => self.receiver_name,
            :address_type => type,
            :province => self.province,
            :city => self.city,
            :area => self.area,
            :street => self.street,
            :location => self.location,
            :postcode => self.postcode
          })
        order["#{type}_address_id"] = order_address.id
        order.save!
      end
    end

    def full_name(province, city, area)
      @name_list = Shoppe::Region.where("code in (?)", [province, city, area]).pluck(:name)
      @full_name = @name_list.join("")
    end

    def reset_default
      if self.default?
        Address.where(:customer_id => self.customer_id).where("id != ? ", self.id).update_all(:default => false)
      elsif Address.where(customer_id: self.customer_id).blank?
        self.default = true
      end
    end

  end
end
