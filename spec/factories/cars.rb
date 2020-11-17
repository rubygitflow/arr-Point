FactoryBot.define do
  factory :car do
    user
    license_plate { 'С123МВ 77' }
    model { 'Moscvich' }
    year_manufacture { '2010' }

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
  end
end
