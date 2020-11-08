class Car < ApplicationRecord
  belongs_to :user
  has_many_attached :pictures

  validates :license_plate, :model, :year_manufacture, presence: true
  
  def service_years
    @service_years ||= Time.zone.now.year - year_manufacture
  end
end
