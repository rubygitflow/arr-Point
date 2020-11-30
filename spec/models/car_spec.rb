require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:user) }
    it { should have_many(:rides) }
  end

  describe 'validations' do
    it { should validate_presence_of :license_plate }
    it { should validate_presence_of :model }
    it { should validate_presence_of :year_manufacture }

    it 'has many attached pictures' do
      expect(Car.new.pictures).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'attach some images' do
    let(:user) { create(:user, :as_driver, :authorized) }

    it 'chooses jpg' do
      expect(Car.count).to eq 0
      car = create(:car, :with_jpg, user: user)
      expect(Car.count).to eq 1
      car.should be_valid
    end
    
    it 'chooses gif' do
      expect(Car.count).to eq 0
      car = create(:car, :with_gif, user: user)
      expect(Car.count).to eq 1
      car.should be_valid
    end
    
    it 'chooses png' do
      expect(Car.count).to eq 0
      car = create(:car, :with_png, user: user)
      expect(Car.count).to eq 1
      car.should be_valid
    end
    
    it 'chooses unknown image' do
      expect(Car.count).to eq 0
      car = create(:car, :with_unknown_image, user: user)
      expect(Car.count).to eq 1
      car.should be_valid
    end
    
    it 'chooses big image' do
      expect(Car.count).to eq 0
      car = create(:car, :with_big_image, user: user)
      expect(Car.count).to eq 1
      expect(car.errors.count).to_not eq 0
    end
    
    it 'chooses not an image' do
      expect(Car.count).to eq 0
      car = create(:car, :with_not_an_image, user: user)
      expect(Car.count).to eq 1
      expect(car.errors.count).to_not eq 0
    end
  end

  describe '#select_workhorse!' do
    let(:car) { create(:car, user: user) }

    it 'select this car as workhorse' do
      expect(car).to_not be_workhorse
      car.select_workhorse!
      expect(car).to be_workhorse
    end
    
    it 'deselect other cars' do
      working_car = create(:car, workhorse: true, user: user)
      car.select_workhorse!
      working_car.reload
      expect(working_car).to_not be_workhorse
    end
  end

end
