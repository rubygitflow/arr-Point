class Car < ApplicationRecord
  belongs_to :user
  has_many :rides, -> { order(created_at: :desc) }
  has_many_attached :pictures

  validates :license_plate, :model, :year_manufacture, presence: true
  validate :pictures_validation
  
  def service_years
    @service_years ||= Time.zone.now.year - year_manufacture
  end

  def select_workhorse!
    Car.transaction do
      user.cars.update_all(workhorse:false)

      # TODO: Подключение GPS-датчика
      x = (55.7558+(rand()/10)).round(5)
      y = (37.6177+(rand()/10)).round(5)
      update!(workhorse: true, coordinates: [x, y])
    end
  end

  private

  def pictures_validation
    # https://github.com/rails/rails/issues/31656
    if pictures.attached?
      pictures.each do |file|
        if file.blob.byte_size > 2.megabytes
          errors.add(:file, 
            I18n.t('activerecord.errors.attachment.photo.invalid_size')
          )
        elsif !file.blob.content_type.starts_with?('image/')
          errors.add(:file, 
            I18n.t('activerecord.errors.attachment.photo.invalid_content_type')
          )
        end
      end
    end
  end
end
