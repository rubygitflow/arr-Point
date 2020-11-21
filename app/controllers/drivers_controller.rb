class DriversController < ApplicationController
  layout :false, only: %i[create update lock]
  before_action :authenticate_user!
  before_action :load_driver, only: %i[show edit update destroy lock car_stats]

  authorize_resource

  def splitter
    @driver = Driver.find_by(user_id: current_user.id)
    if @driver
      params[:id] = @driver.id
      redirect_to @driver
    else
      redirect_to new_driver_path
    end
  end

  def index
    @drivers = Driver.all
  end

  def show
    @car = @driver.user.cars.build
  end

  def new
    @driver ||= Driver.new
  end

  def create
    if current_user.driver?
      @driver = Driver.new(driver_params)
      @driver.user = current_user
      params[:id] = @driver.id
      @driver.save
    else
      head(:forbidden)
    end
  end

  def edit
  end

  def update
    if current_user.owner?(@driver) || current_user.admin
      @driver.update(driver_params)
    else
      head(:forbidden)
    end
  end

  def destroy
    if current_user.owner?(@driver) || current_user.admin
      @driver.destroy
      redirect_to edit_user_registration_path, notice: t('.profile_deleted')
    else
      return redirect_to driver_path, 
      notice: t('.ban_on_deleting_a_profile') 
    end
  end

  def lock
    if current_user.admin && !@driver.user.admin
      @driver.user.toggle!
    else
      if current_user.admin
        flash[:error] = t('.admin_lock_ignored')
        redirect_to drivers_path
        # return redirect_to drivers_path, notice: t('.admin_lock_ignored')        
      else
        head(:forbidden)
      end
    end      
  end

  def car_stats
    @cars = @driver.user.cars
    redirect_to car_rides_path(@cars.first) if @cars.present?
  end

  private

  def load_driver
    @driver = Driver.with_attached_photo.find(params[:id])
  end

  def driver_params
    params.require(:driver).permit(:driver_id, :license_id, :region, 
      :start_driving, :photo)
  end
end
