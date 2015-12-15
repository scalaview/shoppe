module Shoppe
  class Region < ActiveRecord::Base

    def self.getProvice
      self.where(level: 1)

    end

    def self.getCity(provice)
      self.where(level: 2,parentcode: provice)

    end

    def self.getDistrict(city)
      self.where(level: 3,parentcode: city)
    end

  end
end
