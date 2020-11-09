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
    # can :read, :all
  end

  def driver_abilities
    can :read, Driver, user_id: @user.id
    # can :read, Passenger
    can :create, Driver, user_id: @user.id
    can :update, Driver, user_id: @user.id
    
    can :destroy, ActiveStorage::Attachment do |attachment|
      puts("driver_abilities destroy attachment.record=#{attachment.record.inspect}")
      @user.owner?(attachment.record)
    end
  end

  def passenger_abilities
    can :read, Driver
    # can :read, Passenger, user_id: @user.id
    # can :create, Passenger, user_id: @user.id
    # can :update, Passenger, user_id: @user.id
    # can :destroy, Passenger, user_id: @user.id
  end

end
