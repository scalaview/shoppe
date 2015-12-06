require 'digest/md5'

module Shoppe
  class OrderAddress < ActiveRecord::Base

    before_save do
      self.md5 = attributes_md5 if self.md5 != attributes_md5
    end

    def md5Able_attributes
      {
        :province => self.province,
        :city => self.city,
        :area => self.area,
        :street => self.street,
        :location => self.location,
        :postcode => self.postcode,
        :country_id => self.country_id
      }
    end

    def attributes_md5
      Digest::MD5.hexdigest md5Able_attributes.map{|att| "#{att}".downcase.gsub(/[^\d\w]/, "").strip}.join('')
    end

    def match?(address)
      return false if address.blank?
      self.attributes_md5 == self.attributes_md5
    end

  end
end