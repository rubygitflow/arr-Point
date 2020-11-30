class DriverSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes %w[id driver_id license_id experience]
  belongs_to :user
end
