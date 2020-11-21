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
end
