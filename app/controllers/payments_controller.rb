class PaymentsController < ApplicationController
  layout :false, only: %i[pay_off]
  before_action :authenticate_user!
  before_action :load_payment, only: %i[pay_off]

  authorize_resource

  def accept
    pc = params[:pc]
    @payment = Payment.find_by(payment_confirmation: pc)
    @ride = @payment.ride
    @car = @ride.car
  end

  def pay_off
    if current_user.admin
      @payment.to_pay!
    else
      head(:forbidden)
    end      
  end

  private

  def load_payment
    @payment = Payment.find(params[:id])
  end
end
