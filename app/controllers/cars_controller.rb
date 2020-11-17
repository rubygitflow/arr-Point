class CarsController < ApplicationController
  layout :false, only: %i[create update destroy select_workhorse]
  before_action :authenticate_user!
  before_action :find_driver, only: %i[index create]
  before_action :load_car, only: %i[show edit update destroy select_workhorse]

  authorize_resource

  def index
    if @driver.present?
      @cars = @driver.user.cars
    else
      head(:forbidden)
    end
  end

  def show
  end

  def new
    @car ||= Car.new
  end

  def edit
  end

  def create
    if @driver.present?
      # только у пользователя с водительскими правами можно заводить описание машины
      @car = Car.new(car_params)
      @car.user = @driver.user
      params[:id] = @car.id
      @car.save
    else
      head(:forbidden)
    end
  end


  def update
    if current_user.owner?(@car) || current_user.admin
      @car.update(car_params)
    else
      head(:forbidden)
    end
  end

  def destroy
    if current_user.owner?(@car) || current_user.admin
      @car.destroy
    else
      head(:forbidden)
    end
  end

  def select_workhorse   
    if current_user.owner?(@car) || current_user.admin
      @car.select_workhorse!
    else
      head(:forbidden)
    end
  end

  private

  def find_driver
    @driver = Driver.find(params[:driver_id])
  end

  def load_car
    @car = Car.with_attached_pictures.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:license_plate, :model, :year_manufacture, 
      pictures: [])
  end

end
