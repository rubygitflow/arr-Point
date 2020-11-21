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
end
