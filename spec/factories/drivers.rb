FactoryBot.define do
  factory :driver do
    user
    driver_id { '77 77 999999' }
    license_id { '8999999' }
    region { 'Moscow' }
    start_driving { '2010' }

    trait :invalid do
      driver_id { nil }
    end  

    trait :with_photo do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'images', 'incognito.jpg')
        photo = fixture_file_upload(photo_path, 'image/jpeg')
        driver.photo.attach(photo)
      end
    end

    trait :with_jpg do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'images', 'car456.jpg')
        photo = fixture_file_upload(photo_path, 'image/jpeg')
        driver.photo.attach(photo)
      end
    end

    trait :with_png do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'images', 'car234.png')
        photo = fixture_file_upload(photo_path, 'image/png')
        driver.photo.attach(photo)
      end
    end

    trait :with_gif do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'images', 'car345.gif')
        photo = fixture_file_upload(photo_path, 'image/gif')
        driver.photo.attach(photo)
      end
    end

    trait :with_unknown_image do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'images', 'car123.webp')
        photo = fixture_file_upload(photo_path, 'image')
        driver.photo.attach(photo)
      end
    end

    trait :with_big_image do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'images', 'big_car_image.png')
        photo = fixture_file_upload(photo_path, 'image/png')
        driver.photo.attach(photo)
      end
    end

    trait :with_not_an_image do
      after :create do |driver|
        photo_path = Rails.root.join('app', 'assets', 'config', 'manifest.js')
        photo = fixture_file_upload(photo_path, 'image')
        driver.photo.attach(photo)
      end
    end
  end
end
