class CarSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes %w[car.license_plate car.model car.pictures ]
  belongs_to :user
  has_many :pictures

  def pictures
    object.pictures.map do |file|
      {
        name: file.filename.to_s,
        url: rails_blob_path(file, only_path: true)
      }
    end
  end
end

class DriverSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes %w[driver.driver_id driver.license_id]
  has_one :photo

  def photo
    [
      {
        name: photo.filename.to_s,
        url: rails_blob_path(photo, only_path: true)
      }
    ]
  end
end
