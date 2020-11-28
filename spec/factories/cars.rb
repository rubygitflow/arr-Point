FactoryBot.define do
  factory :car do
    user
    license_plate { 'С123МВ 77' }
    model { 'Moscvich' }
    year_manufacture { '2010' }
    workhorse { false }

    trait :invalid do
      license_plate { '' }
      model { '' }
      year_manufacture { '' }
    end  

    trait :with_pictures do
      after :create do |car|
        picture_path1 = Rails.root.join('app', 'assets', 'images', '1234567777.jpg')
        picture_path2 = Rails.root.join('app', 'assets', 'images', '1234567888.jpg')
        picture1 = fixture_file_upload(picture_path1, 'image/jpeg')
        picture2 = fixture_file_upload(picture_path2, 'image/jpeg')
        car.pictures.attach(picture1, picture2)
      end
    end

    trait :with_jpg do
      after :create do |car|
        picture_path = Rails.root.join('app', 'assets', 'images', 'car456.jpg')
        picture = fixture_file_upload(picture_path, 'image/jpeg')
        car.pictures.attach(picture)
      end
    end

    trait :with_png do
      after :create do |car|
        picture_path = Rails.root.join('app', 'assets', 'images', 'car234.png')
        picture = fixture_file_upload(picture_path, 'image/png')
        car.pictures.attach(picture)
      end
    end

    trait :with_gif do
      after :create do |car|
        picture_path = Rails.root.join('app', 'assets', 'images', 'car345.gif')
        picture = fixture_file_upload(picture_path, 'image/gif')
        car.pictures.attach(picture)
      end
    end

    trait :with_unknown_image do
      after :create do |car|
        picture_path = Rails.root.join('app', 'assets', 'images', 'car123.webp')
        picture = fixture_file_upload(picture_path, 'image')
        car.pictures.attach(picture)
      end
    end

    trait :with_big_image do
      after :create do |car|
        picture_path = Rails.root.join('app', 'assets', 'images', 'big_car_image.png')
        picture = fixture_file_upload(picture_path, 'image/png')
        car.pictures.attach(picture)
      end
    end

    trait :with_not_an_image do
      after :create do |car|
        picture_path = Rails.root.join('app', 'assets', 'config', 'manifest.js')
        picture = fixture_file_upload(picture_path, 'image')
        car.pictures.attach(picture)
      end
    end
  end
end
