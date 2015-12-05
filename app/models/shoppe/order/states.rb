require 'state_machines/core'

module Shoppe
  class Order < ActiveRecord::Base
    extend StateMachines::MacroMethods

    # An array of all the available statuses for an order
    # STATUSES = self.state_machines[:status].states.map(&:value)

    # The Shoppe::User who accepted the order
    #
    # @return [Shoppe::User]
    belongs_to :accepter, :class_name => 'Shoppe::User', :foreign_key => 'accepted_by'

    # The Shoppe::User who rejected the order
    #
    # @return [Shoppe::User]
    belongs_to :rejecter, :class_name => 'Shoppe::User', :foreign_key => 'rejected_by'

    # All orders which have been received
    scope :received, -> {where("received_at is not null")}

    # All orders which are currently pending acceptance/rejection
    scope :pending, -> { where(:status => 'received') }

    # All ordered ordered by their ID desending
    scope :ordered, -> { order(:id => :desc)}
    # get the order had been comfirm
    scope :continue, -> { where('status in (?)', [get_status(:init), get_status(:build)]).last }

    # Order.with_state(:parked)                         # also plural #with_states
    # Order.without_states(:first_gear, :second_gear)   # also singular #without_state

    # status

    state_machine :status, :initial => :init do

        state :init,                :value => 0
        state :build,               :value => 1
        state :on_hold,             :value => 2
        state :confirmed,           :value => 3
        state :partial_pay,         :value => 4
        state :payment_auth,        :value => 5
        state :payment_done,        :value => 6
        state :payment_fail,        :value => 7
        state :checkout_success,    :value => 8
        state :packaged,            :value => 9
        state :shipped,             :value => 10
        state :accepted,            :value => 11  #快递返回到货
        state :received,            :value => 12  #用户确认到货
        state :rejected,            :value => 13  #拒收
        state :ask_for_return,      :value => 14
        state :shipping_back,       :value => 15
        state :rejected_ship_back,  :value => 16  #退货拒绝收货
        state :shipped_back,        :value => 17
        state :reject_refund,       :value => 18
        state :refund,              :value => 19
        state :finish,              :value => 20
        state :cancel,              :value => 21

        event :building do
          transition :init => :build
        end

        event :confirming do
          transition :build => :confirmed
        end

        event :rejected do

        end


        # init  初始化
        # building 把shopping cart item copy to order item
        # on hold 使用找人代付，砍价的时候的状态
        # partial pay 找人代付 有人付了一部分
        # confirming  用户查看详细页面
        # confirmed 用户点击确认后
        # payment auth 已经扣费，但是无法确实是否成功，等待api confirm确认
        # payment done  系统成功支付，
        # payment fail 支付系统出错，可以允许再次付款
        # cancel  用户主动取消
        # checkout success 系统对order进行各种操作成功
        # packaged  打包
        # shipped 已经发货
        # ask for return 要求退货
        # shipping back 正在货
        # shipped back 货已经退回
        # reject refund
        # refund 退款
        # finish 不能操作

    end

    def self.get_status(state)
      Shoppe::Order.state_machines[:status].states[state.to_sym].value
    end

  end
end
