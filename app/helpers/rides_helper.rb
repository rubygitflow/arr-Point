module RidesHelper
  def ride_form_options(ride)
    if ride.new_record?
      {model: [ride.car, ride], class: 'bg-secondary', id: "new-ride"} 
    else
      {model: ride, class: 'hidden bg-secondary', id: "edit-ride-#{ride.id}"}
    end
  end

  def ride_errors_div_id(ride)
    ride.new_record? ? 'new-ride-errors' : "ride-#{ride.id}-errors"
  end
end
