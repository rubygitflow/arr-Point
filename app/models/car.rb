class Car < ApplicationRecord
  belongs_to :user
  has_many :rides
  has_many_attached :pictures

  validates :license_plate, :model, :year_manufacture, presence: true
  validate :pictures_validation
  
  def service_years
    @service_years ||= Time.zone.now.year - year_manufacture
  end

  def select_workhorse!
    Car.transaction do
      user.cars.update_all(workhorse:false)
      update!(workhorse: true)
    end
  end

  def pictures_validation
    # https://github.com/rails/rails/issues/31656
    if pictures.attached?
      pictures.each do |file|
        if file.blob.byte_size > 2.megabytes
          file.purge
          errors.add(file.filename, 
            I18n.t('activerecord.errors.attachment.photo.invalid_size'))
        elsif !file.blob.content_type.starts_with?('image/')
          file.purge
          errors.add(file.filename, 
            I18n.t('activerecord.errors.attachment.photo.invalid_content_type'))
        end
      end
    end
  end
end
