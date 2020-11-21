class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :ride

  def to_pay!
  	update!(paid_up: Time.now)
  end
end
