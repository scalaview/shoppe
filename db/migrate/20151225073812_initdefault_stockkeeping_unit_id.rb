class InitdefaultStockkeepingUnitId < ActiveRecord::Migration
  def up
    Shoppe::Product.where(:default_stockkeeping_unit_id => nil).each do |p|
      p.stockkeeping_unit = p.variants.first
      if p.save(validate: false)
        puts " #{p.id} set sku success"
      else
        puts " #{p.id} set sku fail, #{p.errors.full_messages.join(': ')}"
      end
    end
    Shoppe::Product.where(:default_stockkeeping_unit_id => nil).destroy_all
  end
end
