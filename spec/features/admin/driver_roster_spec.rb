require 'rails_helper'

feature 'Admin can manage driver profiles', %{
  To view and edit driver details — licenses, ID cards, photo.
} do
  given(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given(:reg_admin) { create(:user, :as_driver, :admin, :authorized) } 
  background do
    visit new_user_session_path
  end

  scenario 'Admin can view a list of drivers' do  
    login(reg_admin)
    admin = create(:driver, driver_id: '00 001',  user: reg_admin)

    visit drivers_path 

    expect(page).to have_content admin.driver_id
    expect(page).to have_link 'Профиль'

    driver = create(:driver, driver_id: '00 002',  user: reg_driver)
    expect(page).to_not  have_content driver.driver_id

    visit drivers_path 

    # save_and_open_page
    expect(page).to have_content driver.driver_id
  end

  scenario "Non admin can't manage driver profiles" do  
    login(reg_driver)
    visit drivers_path 

    # save_and_open_page
    expect(page).to have_content 'У вас нет прав доступа к этой странице'
  end


  describe "Admin can open show driver's page" do  

    background { login(reg_admin) }
     
    scenario 'first one' do  
      admin = create(:driver, driver_id: '00 001',  user: reg_admin) 
      driver = create(:driver, driver_id: '00 002',  user: reg_driver)
         
      visit drivers_path 

      link = '#driver-'+admin.id.to_s
      find(link).click
      # save_and_open_page

      expect(page).to have_content "№ профиля:"
      expect(page).to have_content admin.driver_id
    end

    scenario 'second one' do 
      admin = create(:driver, driver_id: '00 001',  user: reg_admin) 
      driver = create(:driver, driver_id: '00 002',  user: reg_driver)
         
      visit drivers_path 

      link = '#driver-'+driver.id.to_s
      find(link).click
      # save_and_open_page
      
      expect(page).to have_content "№ профиля:"
      expect(page).to have_content driver.driver_id
    end
  end

end
