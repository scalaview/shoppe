class CreateShoppePaymentMethods < ActiveRecord::Migration
  def change
    create_table :shoppe_payment_methods do |t|
      t.string    :name, null: false
      t.string    :code, null: false
      t.decimal   :poundage,      precision: 8, scale: 2, default: 0.00
      t.integer   :currency_id
      t.boolean   :display, null: false, default: true
      t.integer   :sort_num,  null: false, default: 0

      t.timestamps
    end

    Shoppe::PaymentMethod.create(:name => "微信安全支付", :code => 'wechatpayment')
    Shoppe::PaymentMethod.create(:name => "支付宝", :code => 'alipay')
    Shoppe::PaymentMethod.create(:name => "信用卡支付", :code => 'credit_card')
    Shoppe::PaymentMethod.create(:name => "找朋友代替付", :code => 'pay_for_another')
  end
end
