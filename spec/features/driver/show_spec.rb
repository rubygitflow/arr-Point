require 'rails_helper'

feature 'The driver can view his profile', %q(
  To have access to controls
) do
  given(:user) { create(:user, :as_driver, :authorized) }
  given(:other_user) { create(:user, :as_driver, :authorized) }

  background do
    visit new_user_session_path
    login(user) 
  end

  scenario 'The driver views his details' do
    driver = create(:driver, :with_photo, user: user)
    visit driver_path(driver)

    expect(page).to have_link 'Удалить фотографию'
    expect(page).to have_link 'Отредактировать профиль'
    expect(page).to have_link 'Удалить профиль'

    expect(page).to have_content 'Мой профиль'
    expect(page).to have_content '№ водительского удостоверения'
    expect(page).to have_content '№ разрешения водителя'
    expect(page).to have_content 'Регион'
    expect(page).to have_content 'Год начала'
  end

  scenario 'The driver can open edit profile window', js: true do
    driver = create(:driver, :with_photo, user: user)
    visit driver_path(driver)

    click_on 'Отредактировать профиль'

    expect(page).to have_content '№ водительского удостоверения'
    expect(page).to have_content '№ разрешения водителя'
    expect(page).to have_content 'Регион'
    expect(page).to have_content 'Год начала'

    expect(page).to have_button 'Принять'
  end

  scenario "Driver can't view оther driver's details" do
    driver = create(:driver, :with_photo, user: user)
    logout(user) 

    visit new_user_session_path
    login(other_user) 

    visit driver_path(driver)

    expect(page).to have_content 'У вас нет прав доступа к этой странице'
  end
end
