require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should_not be_able_to :read, Driver }
    # it { should_not be_able_to :read, Passenger }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
    it { should be_able_to :read, :all }
  end

  describe 'for driver' do
    let(:user) { create :user, role: 'Driver' }
    let(:other_user_driver) { create :user, role: 'Driver' }
    let(:user_passenger) { create :user, role: 'Passenger' }

    let(:driver1) { create(:driver, :with_photo, user: user) }
    let(:other_driver) { create(:driver, :with_photo, user: other_user_driver) }
    # let(:passenger1) { create(:passenger, :with_pictures, user: user_passenger) }

    # it { should_not be_able_to :create, create(:passenger, user: user), user: user }
    # it { should_not be_able_to :update, create(:passenger, user: passenger1), user: user }
    # it { should_not be_able_to :destroy, create(:passenger, user: passenger1), user: user  }

    it { should be_able_to :create, create(:driver, user: user) }
    it { should be_able_to :update, create(:driver, user: user), user: user }
    it { should be_able_to :destroy, create(:driver, user: user), user: user  } # what happened?
    it { should_not be_able_to :update, create(:driver, user: other_user_driver), user: user }
    it { should_not be_able_to :destroy, create(:driver, user: other_user_driver), user: user }

    # it { should be_able_to :destroy, driver1.photo, user: user } # what happened?
    it { should_not be_able_to :destroy, other_driver.photo, user: user }

    it { should_not be_able_to :index, create(:driver, user: user) }
    it { should be_able_to :splitter, create(:driver, user: user) }
    it { should be_able_to :show, create(:driver, user: user) }
    it { should be_able_to :new, create(:driver, user: user) }
    it { should be_able_to :edit, create(:driver, user: user) }

    it { should_not be_able_to :index, create(:driver, user: other_user_driver) }
    it { should be_able_to :splitter, create(:driver, user: other_user_driver) }
    it { should_not be_able_to :show, create(:driver, user: other_user_driver) }
    it { should_not be_able_to :new, create(:driver, user: other_user_driver) }
    it { should_not be_able_to :edit, create(:driver, user: other_user_driver) }
    
    it { should be_able_to :show, create(:car, user: user) }
    it { should be_able_to :new, create(:car, user: user) }
    it { should be_able_to :edit, create(:car, user: user) }
    it { should be_able_to :create, create(:car, user: user) }
    it { should be_able_to :update, create(:car, user: user), user: user }
    it { should be_able_to :destroy, create(:car, user: user), user: user  } # what happened?
    it { should be_able_to :select_workhorse, create(:car, user: user) }

    it { should_not be_able_to :show, create(:car, user: other_user_driver) }
    it { should_not be_able_to :new, create(:car, user: other_user_driver) }
    it { should_not be_able_to :edit, create(:car, user: other_user_driver) }
    it { should_not be_able_to :create, create(:car, user: other_user_driver) }
    it { should_not be_able_to :update, create(:car, user: other_user_driver) }
    it { should_not be_able_to :destroy, create(:car, user: other_user_driver)  } # what happened?
    it { should_not be_able_to :select_workhorse, create(:car, user: other_user_driver) }

    # it { should be_able_to :read, create(:passenger, user: user_passenger) }
  end

  describe 'for passenger' do
    let(:user) { create :user, role: 'Passenger' }
    let(:other_user_passenger) { create :user, role: 'Passenger' }
    let(:user_driver) { create :user, role: 'Driver' }

    # let(:passenger1) { create(:passenger, :with_pictures, user: user) }
    # let(:other_passenger) { create(:passenger, :with_pictures, user: other_user_passenger) }
    let(:driver1) { create(:driver, :with_photo, user: user_driver) }

    it { should_not be_able_to :create, create(:driver, user: user), user: user }
    it { should_not be_able_to :update, create(:driver, user: user_driver), user: user }
    it { should_not be_able_to :destroy, create(:driver, user: user_driver), user: user  }

    it { should_not be_able_to :create, create(:car, user: user), user: user }
    it { should_not be_able_to :update, create(:car, user: user_driver), user: user }
    it { should_not be_able_to :destroy, create(:car, user: user_driver), user: user  }
    
    # it { should be_able_to :create, create(:passenger, user: user) }
    # it { should be_able_to :update, create(:passenger, user: user), user: user }
    # it { should be_able_to :destroy, create(:passenger, user: user), user: user }
    # it { should_not be_able_to :update, create(:passenger, user: other_user_passenger), user: user }
    # it { should_not be_able_to :destroy, create(:passenger, user: other_user_passenger), user: user }
    
    # it { should be_able_to :destroy, passenger1.pictures.first }
    # it { should_not be_able_to :destroy, other_passenger.pictures.first }

    it { should be_able_to :read, create(:driver, user: user_driver) }
    it { should be_able_to :read, create(:car, user: user_driver) }
    # it { should_not be_able_to :read, create(:passenger, user: other_user_passenger) }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should_not be_able_to :manage, :all }
    it { should_not be_able_to :read, :all }
  end
end
