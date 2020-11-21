class Ride < ApplicationRecord
  belongs_to :car
  has_one :payment

  validates :cost, numericality: { greater_than_or_equal_to: 0 }

  scope :with_payments, -> (carId) { where(car_id: carId)
    .joins("LEFT OUTER JOIN payments ON (rides.id = payments.ride_id)")
    .select("rides.*, payments.rate as rate, payments.tariff as tariff, 
      payments.price as price, payments.paid_up as paid_up, payments.id as paid_id") }

  def scheduled?
    status == 'Scheduled'
  end

  def started?
    status == 'Execution'
  end

  def completed?
    status == 'Completed'
  end

  def stoped_by_me?
    status == 'Rejected'
  end

  def stoped_by_client?
    status == 'Aborted'
  end

  def finished?
    status == 'Completed' || 'Aborted' || 'Rejected' 
  end
end
