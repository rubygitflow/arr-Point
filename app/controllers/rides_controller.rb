class RidesController < ApplicationController
  layout :false, only: %i[create destroy update]
  before_action :authenticate_user!
  before_action :find_car, only: %i[menu index create]
  before_action :load_ride, only: %i[show edit update destroy 
                                     execute complete abort reject]

  authorize_resource

  def menu
    if @car.present?
      @rides = @car.rides.where(status: ['Scheduled','Execution'])
      @ride = @car.rides.build
    else
      head(:forbidden)
    end
  end

  def index
    if @car.present?
      @rides = @car.rides
    else
      head(:forbidden)
    end
  end

  def show
  end

  def new
    @ride ||= Ride.new
  end

  def edit
  end

  def create
    if @car.present?
      @ride = Ride.new(ride_params)
      @ride.car = @car
      params[:id] = @ride.id
      @ride.save
    else
      head(:forbidden)
    end
  end

  def update
    @ride.update(ride_params)
    # Here without some kind of special processing 
  end

  def destroy
    @ride.destroy
  end
  
  def execute
    @ride.update!(status: 'Execution')
    # Here some kind of special processing 
    redirect_to root_path+"?car=#{@ride.car_id}"
  end

  def complete
    @ride.update!(status: 'Completed')
    # Here some kind of special processing 
    redirect_to root_path
  end

  def abort
    @ride.update!(status: 'Aborted')
    # Here some kind of special processing 
    redirect_to root_path
  end

  def reject
    @ride.update!(status: 'Rejected')
    # Here some kind of special processing 
    redirect_to root_path
  end

  private

  def find_car
    @car = Car.with_attached_pictures.find(params[:car_id])
  end

  def ride_params
    params.require(:ride).permit(:departure, :arrival, :when, :cost)
  end

  def load_ride
    @ride = Ride.find(params[:id])
  end

end
