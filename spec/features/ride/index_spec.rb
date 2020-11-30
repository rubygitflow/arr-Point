require 'rails_helper'

feature "Driver can look at rides and payments list", %{
  To see all rides and their payment statuses.
} do
  given!(:user) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:driver) { create(:driver, user: reg_driver) } 
  given!(:car) { create(:car, :workhorse, user: reg_driver, license_plate: '123') } 
  given!(:other_car) { create(:car, user: reg_driver, license_plate: '456') } 
  given!(:ride) { create(:ride, :execute, arrival: 'Wondrous', car: car) } 
  given!(:other_ride) { create(:ride, :execute, arrival: 'Dangerous', car: other_car) } 

  describe "Owner" do  
    background do
      visit new_user_session_path
      login(reg_driver)
      visit car_rides_path(car)
    end

    scenario 'can see payments list by default car', js: true do 
      expect(page).to  have_content car.license_plate
      expect(page).to have_content 'История поездок'
      expect(page).to have_content 'Wondrous'
    end

    scenario 'can open payment details for any car' do
      expect(page).to have_link '123'
      expect(page).to have_link '456'

      click_on '456'

      expect(page).to  have_content other_car.license_plate
      expect(page).to have_content 'История поездок'
      expect(page).to have_content 'Dangerous'
    end

    scenario 'can open payment details' do
      expect(page).to have_link 'Реквизиты для оплаты'

      click_on 'Реквизиты для оплаты'

      expect(response_headers["Content-Type"]).to eq "application/pdf"
    end
  end 

  describe "Alien" do  
    background do
      visit new_user_session_path
      login(user)
      visit car_rides_path(car)
    end

    scenario 'can not see payments list by default car', js: true do 
      expect(page).to have_content '403'
    end
  end 
end
