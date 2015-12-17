module Shoppe
  class Region < ActiveRecord::Base

    def self.getProvince
      self.where(level: 1)

    end

    def self.getCity(province)
      self.where(level: 2,parentcode: province)

    end

    def self.getDistrict(city)
      self.where(level: 3,parentcode: city)
    end

  end
end
