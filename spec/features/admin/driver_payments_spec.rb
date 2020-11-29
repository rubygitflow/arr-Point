require 'rails_helper'

feature "Admin can look at and manage driver's payments", %{
  To repay the payment if the rides exist.
} do
  given!(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:driver) { create(:driver, user: reg_driver) } 
  given!(:car) { create(:car, user: reg_driver, workhorse: true) } 
  given!(:ride) { create(:ride, :execute, arrival: 'Wondrous', car: car) } 
  given!(:reg_admin) { create(:user, :admin, :authorized) } 

  given!(:user) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:other_driver) { create(:driver, user: user) } 

  background do
    visit new_user_session_path
    login(reg_admin)
    visit drivers_path
  end

  describe "Admin" do  
    scenario 'can get payments list by the driver', js: true do 
      expect(page).to  have_content driver.id

      find("#driver-payment-#{reg_driver.id}").click

      expect(page).to have_content 'История поездок'
      expect(page).to have_content 'Wondrous'
    end

    scenario 'may get a system failure when the driver has an empty list of cars',
    js: true do 
      expect(page).to  have_content other_driver.id

      find("#driver-payment-#{user.id}").click

      expect(page).to have_content 'У водителя нет зарегистрированных автомобилей'
    end

    scenario 'can manage ride payments from the driver', js: true do 
      payment = create(:payment, ride: ride, user: reg_driver) 

      find("#driver-payment-#{reg_driver.id}").click

      expect(page).to have_content 'История поездок'
      expect(page).to have_content 'Wondrous'

      find("#paid-control-#{payment.id}").click

      expect(page).to have_content 'История поездок'
      expect(page).not_to have_css("#paid-control-#{payment.id}")
      # save_and_open_page
    end
  end
end
