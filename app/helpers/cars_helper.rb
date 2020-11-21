module CarsHelper
  def car_form_options(car)
    if car.new_record?
      {model: [car.user.driver, car], class: 'bg-secondary'} 
    else
      {model: car, class: 'hidden bg-secondary', id: "edit-car-#{car.id}"}
    end
  end

  def car_errors_div_id(car)
    car.new_record? ? 'new-car-errors' : "car-#{car.id}-errors"
  end
end
