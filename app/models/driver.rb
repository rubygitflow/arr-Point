class Driver < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
        
  validates :driver_id, :region, :start_driving, presence: true
  validate :photo_validation

  
  def experience
    @experience ||= Time.zone.now.year - start_driving
  end

  def photo_validation
    # https://github.com/rails/rails/issues/31656
    if photo.attached?
      if photo.blob.byte_size > 2.megabytes
        photo.purge
        errors.add(:photo, 
          I18n.t('activerecord.errors.attachment.photo.invalid_size'))
      elsif !photo.blob.content_type.starts_with?('image/')
        photo.purge
        errors.add(:photo, 
          I18n.t('activerecord.errors.attachment.photo.invalid_content_type'))
      end
    end
  end
end
