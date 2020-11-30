require 'rails_helper'

RSpec.describe Driver, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :driver_id }
    it { should validate_presence_of :region }
    it { should validate_presence_of :start_driving }

    it 'has one attached photo' do
      expect(Driver.new.photo).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe 'uniqueness validation' do
    subject { FactoryBot.create(:driver) }
    it { should validate_uniqueness_of :user }
  end

  describe 'attach an image' do
    let(:user) { create(:user, :as_driver, :authorized) }

    it 'chooses jpg' do
      expect(Driver.count).to eq 0
      driver = create(:driver, :with_jpg, user: user)
      expect(Driver.count).to eq 1
      driver.should be_valid
    end
    
    it 'chooses gif' do
      expect(Driver.count).to eq 0
      driver = create(:driver, :with_gif, user: user)
      expect(Driver.count).to eq 1
      driver.should be_valid
    end
    
    it 'chooses png' do
      expect(Driver.count).to eq 0
      driver = create(:driver, :with_png, user: user)
      expect(Driver.count).to eq 1
      driver.should be_valid
    end
    
    it 'chooses unknown image' do
      expect(Driver.count).to eq 0
      driver = create(:driver, :with_unknown_image, user: user)
      expect(Driver.count).to eq 1
      driver.should be_valid
    end
    
    it 'chooses big image' do
      expect(Driver.count).to eq 0
      driver = create(:driver, :with_big_image, user: user)
      expect(Driver.count).to eq 1
      expect(driver.errors.count).to_not eq 0
    end
    
    it 'chooses not an image' do
      expect(Driver.count).to eq 0
      driver = create(:driver, :with_not_an_image, user: user)
      expect(Driver.count).to eq 1
      expect(driver.errors.count).to_not eq 0
    end
  end

end
