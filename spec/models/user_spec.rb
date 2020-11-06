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
end
