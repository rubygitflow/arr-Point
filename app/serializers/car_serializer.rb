class CarSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes %w[id 
                license_plate 
                model 
                pictures 
                year_manufacture 
                workhorse 
                coordinates]
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
