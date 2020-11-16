class Ride < ApplicationRecord
  belongs_to :car
  has_one :payment
end
