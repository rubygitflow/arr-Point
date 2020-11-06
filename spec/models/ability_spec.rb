require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    # it { should_not be_able_to :read, Driver_detail }
    # it { should_not be_able_to :read, Passenger_detail }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for driver' do
    let(:driver) { create :user, role: 'Driver' }
    let(:other_driver) { create :user, role: 'Driver' }
    let(:passenger) { create :user, role: 'Passenger' }

    # let(:driver_detail_1) { create(:driver_detail, :with_files, user: driver) }
    # let(:passenger_detail_1) { create(:passenger_detail, :with_files, user: passenger) }

    # it { should_not be_able_to :create, create(:passenger_detail, user: driver), user: driver }
    # it { should_not be_able_to :update, create(:passenger_detail, user: passenger), user: driver }
    # it { should_not be_able_to :destroy, create(:passenger_detail, user: passenger), user: driver  }

    # it { should be_able_to :create, Driver_detail }
    # it { should be_able_to :update, create(:driver_detail, user: driver), user: driver }
    # it { should be_able_to :destroy, create(:driver_detail, user: driver), user: driver  }
    # it { should_not be_able_to :update, create(:driver_detail, user: other_driver), user: driver }
    # it { should_not be_able_to :destroy, create(:driver_detail, user: other_driver), user: driver }

    # it { should_not be_able_to :read, Driver_detail }
    # it { should be_able_to :read, Passenger_detail }
  end

  describe 'for passenger' do
    let(:driver) { create :user, role: 'Driver' }
    let(:passenger) { create :user, role: 'Passenger' }
    let(:other_passenger) { create :user, role: 'Passenger' }

    # let(:driver_detail_1) { create(:driver_detail, :with_files, user: driver) }
    # let(:passenger_detail_1) { create(:passenger_detail, :with_files, user: passenger) }

    # it { should_not be_able_to :create, create(:driver_detail, user: passenger), user: passenger }
    # it { should_not be_able_to :update, create(:driver_detail, user: driver), user: passenger }
    # it { should_not be_able_to :destroy, create(:driver_detail, user: driver), user: passenger  }
    
    # it { should be_able_to :create, Passenger_detail }
    # it { should be_able_to :update, create(:passenger_detail, user: driver), user: passenger }
    # it { should be_able_to :destroy, create(:passenger_detail, user: passenger), user: passenger }
    # it { should_not be_able_to :update, create(:passenger_detail, user: other_passenger), user: passenger }
    # it { should_not be_able_to :destroy, create(:passenger_detail, user: other_passenger), user: passenger }
    
    # it { should be_able_to :read, Driver_detail }
    # it { should_not be_able_to :read, Passenger_detail }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
  end
end
