class RidesController < ApplicationController
  layout :false, only: %i[create destroy update]
  before_action :authenticate_user!
  before_action :find_car, only: %i[menu index new create]
  before_action :load_ride, only: %i[show edit update destroy 
                                     execute complete abort reject]

  authorize_resource

  def menu
    if current_user.owner?(@car) || current_user.admin
      @rides = @car.rides.in_processing(@car.id)
      @ride = @car.rides.build
    else
      head(:forbidden)
    end
  end

  def index
    if current_user.owner?(@car) || current_user.admin
      @rides_payments = @car.rides.with_payments(@car.id)
      @cars = @car.user.cars
    else
      head(:forbidden)
    end
  end

  def show
    if current_user.owner?(@ride.car) || current_user.admin
    else
      head(:forbidden)
    end
  end

  def new
    if current_user.owner?(@car) || current_user.admin
      @ride = @car.rides.new
    else
      head(:forbidden)
    end
  end

  def edit
    if current_user.owner?(@ride.car) || current_user.admin
    else
      head(:forbidden)
    end
  end

  def create
    if current_user.owner?(@car) || current_user.admin
      @ride = @car.rides.create(ride_params)
    else
      head(:forbidden)
    end
  end

  def update
    if current_user.owner?(@ride.car) || current_user.admin
      @ride.update(ride_params)
      # Here without some kind of special processing 
    else
      head(:forbidden)
    end
  end

  def destroy
    if current_user.owner?(@ride.car) || current_user.admin
      @ride.destroy
    else
      head(:forbidden)
    end
  end
  
  def execute
    if current_user.owner?(@ride.car) || current_user.admin
      @ride.update!(status: 'Execution')
      # Here some kind of special processing 
      # TODO: запустить ApplicationJob по регистрации GPS данных - 
      #       GEO-Path - у пассажира и у водителя 
      redirect_to root_path+"?car=#{@ride.car_id}"
    else
      head(:forbidden)
    end
  end

  def complete
    if current_user.owner?(@ride.car) || current_user.admin
      if !@ride.finished?
        @ride.update!(status: 'Completed')
        # Here some kind of special processing 
        # TODO: остановить ApplicationJob по регистрации GPS данных - 
        #       GEO-Path - у пассажира и у водителя 
        service = DriverPaymentService.new(@ride, current_user)
        result = service.call
        if result
          redirect_to accept_payments_path+"?pc=#{result}"
        else
          return redirect_to root_path, 
            notice: t('.driver_payment_service_error')
        end
      else
        return redirect_to back_url, 
          notice: t('.driver_payment_service_accepted')
      end
    else
      head(:forbidden)
    end
  end

  def abort
    if current_user.owner?(@ride.car) || current_user.admin
      @ride.update!(status: 'Aborted')
      # Here some kind of special processing 
      redirect_to root_path
    else
      head(:forbidden)
    end
  end

  def reject
    if current_user.owner?(@ride.car) || current_user.admin
      @ride.update!(status: 'Rejected')
      # Here some kind of special processing 
      redirect_to root_path
    else
      head(:forbidden)
    end
  end

  private

  def find_car
    @car = Car.with_attached_pictures.find(params[:car_id])
  end

  def ride_params
    params.require(:ride).permit(:departure, :arrival, :what_time, :cost)
  end

  def load_ride
    @ride = Ride.find(params[:id])
  end
end
