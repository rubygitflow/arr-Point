require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'uniqueness validation' do
    subject { FactoryBot.create(:user) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'presence validation' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :email }
    it { should validate_presence_of :role }
    it { should validate_presence_of :password }
  end

  describe 'acceptance validation' do
    it { should validate_acceptance_of(:role_rules_accepted) }
  end

  describe 'associations' do
    it { should have_one(:driver).dependent(:destroy) }
    it { should have_many(:cars).dependent(:destroy) }
    it { should have_many(:payments) }
  end

  describe 'Scopes' do
    # https://stackoverflow.com/questions/17817020/testing-default-scope-in-rspec
    let!(:driver) { create(:user, :as_driver, :authorized) }
    let!(:other_driver) { create(:user, :as_driver, :authorized) }
    let!(:third_driver) { create(:user, :as_driver, :authorized) }
    let!(:car1) { create(:car,  user: driver, workhorse: true) }
    let!(:car2) { create(:car,  user: driver) }
    let!(:other_car1) { create(:car,  user: other_driver) }
    let!(:other_car2) { create(:car,  user: other_driver, workhorse: true) }
    let!(:third_car1) { create(:car,  user: other_driver) }

    it 'is available cars from drivers' do
      expect(User.available_cars.count).to eq 2
    end
  end
end

