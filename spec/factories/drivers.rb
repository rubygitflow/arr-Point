FactoryBot.define do
  factory :driver do
    user
    driver_id { '77 77 999999' }
    license_id { '8999999' }
    region { 'Moscow' }
    start_driving { '2010' }
  end

  trait :with_photo do
    after :create do |driver|
      photo_path = Rails.root.join('app', 'assets', 'images', 'incognito.jpg')
      photo = fixture_file_upload(photo_path, 'image/jpeg')
      driver.photo.attach(photo)
    end
  end
end
