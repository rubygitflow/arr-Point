require 'rails_helper'

feature "Driver can look at planing and executing rides list", %{
  To see and manage them.
} do
  given!(:user) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:driver) { create(:driver, user: reg_driver) } 
  given!(:car) { create(:car, :with_pictures, user: reg_driver, license_plate: '123') } 
  given!(:other_car) { create(:car, :workhorse, user: reg_driver, license_plate: '456') } 

  describe "Owner of cars" do  
    background do
      visit new_user_session_path
      login(reg_driver)
      visit driver_path(driver) # NOT driver_cars_path(driver)
    end

    scenario 'can see them all together in his profile page', js: true do 
      expect(page).to  have_content '123'
      expect(page).to  have_content '456'
    end

    scenario 'can remove any car description', js: true do 
      expect(page).to have_link(nil, href: "/cars/#{car.id}")
      within "#car-#{car.id}" do
        accept_confirm do
          click_on "Удалить описание автомобиля" 
        end
      end
      expect(page).to have_content 'Мой профиль'
      expect(page).not_to have_content '123'

      expect(page).to have_link(nil, href: "/cars/#{other_car.id}")
      within "#car-#{other_car.id}" do
        accept_confirm do
          click_on "Удалить описание автомобиля" 
        end
      end
      expect(page).to have_content 'Мой профиль'
      expect(page).not_to have_content '456'
    end

    scenario 'can create new car description with attached files', js: true do 
      within '#new-car' do
        attach_file 'Picture', ["#{Rails.root}/public/icons/guy.png", "#{Rails.root}/public/icons/passenger.png"]

        find('#car_license_plate').set('LLL')
        find('#car_model').set('BNW')
        find("#car_year_manufacture").set('2000')
        click_button "Принять" 
      end    
      expect(page).to have_content "LLL"
      expect(page).to have_content "BNW"
      expect(page).to have_content "2000"
    end

    scenario 'can put the car on the route', js: true do 
      within "#car-#{car.id}" do
        click_on 'Поставить на маршрут'
        expect(page).to have_content 'На маршруте'
        expect(page).to_not have_link 'Поставить на маршрут'
      end
      within "#car-#{other_car.id}" do
        click_on 'Поставить на маршрут'
        expect(page).to have_content 'На маршруте'
        expect(page).to_not have_link 'Поставить на маршрут'
      end

      expect(page.all('.card-title').size).to eq 1
    end


    scenario 'can go to registration of transportation orders', js: true do 
      within "#car-#{other_car.id}" do
        # save_and_open_page
        expect(page).not_to have_link 'Поставить на маршрут'
        expect(page).to have_content 'На маршруте'
        click_on 'Регистрация заказа'
      end
      expect(page).to have_content 'Управление поездками'
    end
  end 

  describe "An alien except admin", js: true do  
    background do
      visit new_user_session_path
      login(user)
      visit driver_path(driver) # NOT driver_cars_path(driver)
    end

    scenario 'can not see cars list the current profile' do 
      expect(page).to have_content 'У вас нет прав доступа к этой странице'
    end
  end 
end
