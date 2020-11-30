require 'rails_helper'

feature 'The driver can view financial indicators of his ride', %q(
  To accept future payment
) do

  given!(:user) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:driver) { create(:driver, user: user) } 
  given!(:car) { create(:car, user: user, workhorse: true) } 
  given!(:ride) { create(:ride, :execute, car: car) } 

  given!(:reg_admin) { create(:user, :admin, :authorized) } 
  given!(:other_user) { create(:user, :as_driver,  :not_an_admin, :authorized) } 

  background do
    visit new_user_session_path
  end


  scenario "The driver follows the app's rules" do
    login(user) 
    visit menu_car_rides_path(car)
    expect(page).to have_link 'Завершить'

    click_link 'Завершить'

    # save_and_open_page
    expect(page).to have_content 'Сделка учтена'
  end

  describe "The user doesn't follow the app's rules", js: true do
    scenario "user is owner of current account" do
      login(user) 
      visit accept_payments_path
      expect(page).to have_content '403'
    end

    scenario "user is admin" do
      login(reg_admin) 
      visit accept_payments_path
      expect(page).to have_content '403'
    end

    scenario "user is other driver" do
      login(other_user) 
      visit accept_payments_path
      expect(page).to have_content '403'
    end
  end

end
