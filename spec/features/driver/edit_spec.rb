require 'rails_helper'

feature 'Driver can edit his profile' do

  given(:user) { create(:user, :as_driver, :authorized) }
  given(:other_user) { create(:user, :as_driver, :authorized) }

  background do
    visit new_user_session_path
    login(user) 
  end

  scenario "Driver can't edit оther driver's details" do
    driver = create(:driver, :with_photo, user: user)
    logout(user) 

    visit new_user_session_path
    login(other_user) 

    visit edit_driver_path(driver)

    expect(page).to have_content 'У вас нет доступа к этому ресурсу'
  end

  describe 'The driver edits his profile/details', js: true do
    given(:driver) { create(:driver, :with_photo, user: user) }
    
    background { visit edit_driver_path(driver) }

    scenario 'and changes all fields without errors' do
      fill_driver_profile
      click_on 'Принять'

      expect(page).to have_content '00 00 123456'
      expect(page).to have_content 'qwerty_001'
      expect(page).to have_content 'Magnitogorsk'
      expect(page).to have_content '2001'
    end


    scenario 'and edits his profile incorrectly' do
      find('#driver_driver_id').set('')
      find("#driver_region").set('')
      find("#driver_start_driving").set('')

      click_on 'Принять'

      expect(page).to have_content "сохранение не удалось"
      expect(page).to have_content "не может быть пустым"
    end

  end
end
