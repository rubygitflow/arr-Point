require 'rails_helper'

feature 'Admin can' do
  given(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given(:reg_admin) { create(:user, :as_driver, :admin, :authorized) } 
  background do
    visit new_user_session_path
  end

  scenario "change driver's profile", js: true do  
    login(reg_admin)
    admin = create(:driver, driver_id: '00 001',  user: reg_admin) 
    driver = create(:driver, driver_id: '00 002',  user: reg_driver)
         
    visit "/drivers/"+driver.id.to_s 

    click_link  'Отредактировать профиль'

    fill_new_driver_profile

    click_on 'Принять'

    expect(page).to have_content "№ водительского удостоверения"
    expect(page).to have_content '99 99 000111'
    expect(page).to have_content "Ваш профиль успешно обновлен."
    # save_and_open_page
  end

end
