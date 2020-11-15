class DriversController < ApplicationController
  layout :false, only: %i[create update]
  before_action :authenticate_user!
  before_action :load_driver, only: %i[show edit update destroy]

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
    # @cars = current_user.cars
  end

  def new
    @driver ||= Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    @driver.user = current_user
    params[:id] = @driver.id
    @driver.save
  end

  def edit
  end

  def update
    @driver.update(driver_params)
  end

  def destroy
    if current_user.owner?(@driver)
      @driver.destroy
      redirect_to edit_user_registration_path, notice: t('.profile_deleted')
    else
      return redirect_to driver_path, 
      notice: t('.ban_on_deleting_a_profile') 
    end
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
