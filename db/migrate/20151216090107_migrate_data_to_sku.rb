class MigrateDataToSku < ActiveRecord::Migration
  def up
    transaction do
      Shoppe::Product.where("parent_id is not null").each do |product|
        type = Shoppe::VariantType.create({name: 'color'})
        value = type.variant_values.create({
            name: product.name
          })
        sku = Shoppe::StockkeepingUnit.create({
            :product_id => product.parent_id,
            :sku  => product.sku,
            :active => product.active,
            :stock_control => product.stock_control,
            :weight => product.weight,
            :cost_price => product.cost_price,
            :price => product.price,
            :tax_rate_id => product.tax_rate_id
          })
        Shoppe::ProductVariantValue.create({
            :stockkeeping_unit_id => sku.id,
            :variant_value_id => value.id,
            :variant_type_id => type.id
          })
      end

      Shoppe::Product.where("parent_id is null").each do |product|
        is_done = false
        if product.stockkeeping_unit.blank?
          if product.variants.present?
            is_done = product.update_attribute(:default_stockkeeping_unit_id, product.variants.last.id)
          else
            is_done = product.create_stockkeeping_unit({
                :product_id => product.id,
                :sku  => product.sku,
                :active => product.active,
                :stock_control => product.stock_control,
                :weight => product.weight,
                :cost_price => product.cost_price,
                :price => product.price,
                :tax_rate_id => product.tax_rate_id
              })
          end
        else
          is_done = product.stockkeeping_unit.update_attributes({
              :product_id => product.id,
              :sku  => product.sku,
              :active => product.active,
              :stock_control => product.stock_control,
              :weight => product.weight,
              :cost_price => product.cost_price,
              :price => product.price,
              :tax_rate_id => product.tax_rate_id
            })
        end
        if is_done
          puts "#{product.id} migrate done, #{product.default_stockkeeping_unit_id}"
        else
          puts "#{product.id} migrate fail, #{product.errors.full_messages.join('; ')}"
        end

      end
    end

    change_table(:shoppe_products) do |t|
      t.remove :parent_id
      t.remove :sku
      t.remove :stock_control
      t.remove :weight
      t.remove :cost_price
      t.remove :price
      t.remove :tax_rate_id
      t.remove :default
    end

  end
end
