class Ride < ApplicationRecord
  belongs_to :car
  has_one :payment

  validates :cost, numericality: { greater_than_or_equal_to: 0 }

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
