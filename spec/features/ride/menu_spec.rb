require 'rails_helper'

feature "Driver can look at planing and executing rides list", %{
  To see and manage them.
} do
  given!(:user) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given!(:driver) { create(:driver, user: reg_driver) } 
  given!(:car) { create(:car, :workhorse, user: reg_driver, license_plate: '123') } 
  given!(:s_ride) { create(:ride, :schedule, car: car, arrival: 'sVillage' ) } 
  given!(:e_ride) { create(:ride, :execute, car: car, arrival: 'eVillage') } 
  given!(:c_ride) { create(:ride, :complete, car: car, arrival: 'cVillage') } 
  given!(:r_ride) { create(:ride, :reject, car: car, arrival: 'rVillage') } 
  given!(:a_ride) { create(:ride, :abort, car: car, arrival: 'aVillage') } 

  describe "Owner of car" do  
    background do
      visit new_user_session_path
      login(reg_driver)
      visit menu_car_rides_path(car)
    end

    scenario 'can see Scheduled ride' do 
      expect(page).to  have_content 'sVillage'
    end

    scenario 'can see Performing ride' do 
      expect(page).to  have_content 'eVillage'
    end

    scenario 'can not see Completed ride' do
      expect(page).not_to have_content 'cVillage'
    end

    scenario 'can not see Rejected ride' do
      expect(page).not_to have_content 'rVillage'
    end

    scenario 'can not see Aborted ride' do
      expect(page).not_to have_content 'aVillage'
    end

    scenario 'can stop Performing ride' do 
      expect(page).to have_link(nil, href: "/rides/#{e_ride.id}/complete")
      within "#ride-#{e_ride.id}" do
        click_link 'Завершить'
      end    
      expect(page).to have_content 'Сделка учтена'
      click_link 'Назад'
      expect(page).to have_content 'Управление поездками'
      expect(page).not_to have_content 'eVillage'
    end

    scenario 'can start Scheduled ride' do 
      expect(page).to have_link(nil, href: "/rides/#{s_ride.id}/execute")
      within "#ride-#{s_ride.id}" do
        click_link 'Поехали'
      end    
      expect(page).to have_css('.map')
      visit menu_car_rides_path(car)
      within "#ride-#{s_ride.id}" do
        expect(page).to have_content 'sVillage'
        expect(page).to have_link 'Завершить'
      end    
    end

    scenario 'can abort Scheduled ride', js: true do 
      expect(page).to have_link(nil, href: "/rides/#{s_ride.id}/abort")
      within "#ride-#{s_ride.id}" do
        click_link 'Отклонено клиентом'
      end    
      expect(page).not_to have_content 'sVillage'
    end

    scenario 'can reject Scheduled ride', js: true do 
      expect(page).to have_link(nil, href: "/rides/#{s_ride.id}/reject")
      within "#ride-#{s_ride.id}" do
        click_link 'Отклонено мной'
      end    
      expect(page).not_to have_content 'sVillage'
    end

    scenario 'can edit certain ride', js: true do 
      # https://devhints.io/capybara
      within "#ride-#{s_ride.id}" do
        click_link 'Редактировать описание поездки'
        find('#ride_departure').set('UU1')
        find('#ride_arrival').set('BB1')
        find("#ride_what_time").set('01:01')
        find('#ride_cost').set(1000)
        click_button "Принять" 
      end    
      expect(page).to have_content "UU1"
      expect(page).to have_content "BB1"
      expect(page).to have_content '01:01'
      expect(page).to have_content "1000"

      within "#ride-#{e_ride.id}" do
        click_link 'Редактировать описание поездки'
        find('#ride_departure').set('UU2')
        find('#ride_arrival').set('BB2')
        find("#ride_what_time").set('02:02')
        find('#ride_cost').set(2000)
        click_button "Принять" 
      end    
      expect(page).to have_content "UU2"
      expect(page).to have_content "BB2"
      expect(page).to have_content '02:02'
      expect(page).to have_content "2000"
    end

    scenario 'can remove planned ride', js: true do 
      expect(page).to have_link(nil, href: "/rides/#{s_ride.id}")
      expect(page).not_to have_link(nil, href: "/rides/#{e_ride.id}")
      within "#ride-#{s_ride.id}" do
        accept_confirm do
          click_on "Удалить описание поездки" 
        end
      end
      expect(page).to have_content 'Управление поездками'
      expect(page).not_to have_content 'sVillage'
    end

    scenario 'can create new ride', js: true do 
      within '#new-ride' do
        find('#ride_departure').set('UUU')
        find('#ride_arrival').set('BBB')
        find("#ride_what_time").set('00:00')
        find('#ride_cost').set(100)
        click_button "Принять" 
      end    
      expect(page).to have_content "UUU"
      expect(page).to have_content "BBB"
      expect(page).to have_content '00:00'
      expect(page).to have_content "100"
    end
  end 

  describe "An alien except admin", js: true do  
    background do
      visit new_user_session_path
      login(user)
      visit menu_car_rides_path(car)
    end

    scenario 'can not see rides list by default car' do 
      expect(page).to have_content '403'
    end
  end 
end
