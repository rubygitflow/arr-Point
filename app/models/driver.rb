class Driver < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  validates :driver_id, :region, :start_driving, presence: true
  
  def experience
    @experience ||= Time.zone.now.year - start_driving
  end
end
