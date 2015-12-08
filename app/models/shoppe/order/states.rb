require "finite_machine"

module Shoppe
  class Order < ActiveRecord::Base

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
    scope :continue, -> { where('status in (?)', [STATUS_MAP[:init], STATUS_MAP[:build]]).last }

    # Order.with_state(:parked)                         # also plural #with_states
    # Order.without_states(:first_gear, :second_gear)   # also singular #without_state

    EVENTS = {
     :building =>           { :init => :build },
     :confirming =>         { :build => :confirmed },
     :pause =>               {[:build, :payment_failed] => :on_hold },
     :pay_by_another =>      {:build => :partial_payment },
     :read_to_pay =>         {[:on_hold, :partial_payment, :build] => :payment_auth },
     :payment_success =>    { :payment_auth => :payment_done },
     :payment_fail =>       { :payment_auth => :payment_failed },
     :checkout_done =>      { :payment_done => :checkout_success },
     :cancel =>             {[:on_hold, :partial_payment, :build, :payment_done, :payment_failed, :checkout_success] => :canceled },

     :packag =>             { :checkout_success => :packaged },
     :ship =>               { :packaged => :shipped },
     :acception =>          { :shipped => :accepted },
     :receive =>            { :shipped => :received },
     :finish =>             { :accepted => :finished },
     :reject =>             { :shipped => :rejected },
     :ask_for_return =>      {[:accepted, :rejected] => :return },
     :ship_back =>          { :return => :shipping_back },
     :reject_ship_back =>   { :shipping_back => :rejected_ship_back },
     :receive_ship_back =>  { :shipping_back => :shipped_back },
     :reject_refund =>       {[:rejected_ship_back, :shipped_back] => :rejected_refund },
     :refund =>              {[:payment_done, :shipped_back] => :refunded },
     :refund_finish =>       {[:received, :rejected_refund, :refunded] => :refund_finished },
   }

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

   STATUS = EVENTS.values.map{|t| t.values + t.keys}.flatten.uniq

   STATUS_MAP = Hash[STATUS.zip(STATUS)]

    before_validation :set_initial_state, on: :create

    def set_initial_state
      self.status = manage.current
    end

    after_find :restore_state
    after_initialize :restore_state

    def restore_state
      manage.restore!(status.to_sym) if status.present?
    end

    # status
    def manage
      context = self
      @manage ||= FiniteMachine.define do
        target context

        initial :init

        events {
          EVENTS.deep_dup.each do |k, v|
            event k, v
          end
        }

        callbacks {
          on_enter do |event|
            target.status = state.try(:to_sym)
          end
        }
      end
    end

  end
end
