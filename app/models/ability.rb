# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
      if user.driver?
        driver_abilities
      elsif user.passenger?
        passenger_abilities
      end
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all
  end

  def driver_abilities
    # can :create, Driver_detail
    # can :update, Driver_detail, user_id: user.id
    # can :destroy, Driver_detail, user_id: user.id
  end

  def passenger_abilities
    # can :create, Passenger_detail
    # can :update, Passenger_detail, user_id: user.id
    # can :destroy, Passenger_detail, user_id: user.id
  end

end
