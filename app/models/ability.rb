# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    @user = user

    if user
      if user.driver?
        driver_abilities
      elsif user.passenger?
        passenger_abilities
      end
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
  end

  def admin_abilities
    can :manage, :all
    can :read, :all
  end

  def user_abilities
  end

  def driver_abilities
    can [:splitter], Driver
    can [:show, :new, :edit], Driver, user: @user
    # can :read, Passenger
    can :create, Driver, user: @user
    can :update, Driver, user: @user
    can :destroy, Driver, user: @user

    can :destroy, ActiveStorage::Attachment do |attachment|
      @user.owner?(attachment.record)
    end
  end

  def passenger_abilities
    can :read, Driver
    # can :read, Passenger, user: @user.id
    # can :create, Passenger, user: @user.id
    # can :update, Passenger, user: @user.id
    # can :destroy, Passenger, user: @user.id
  end

end
