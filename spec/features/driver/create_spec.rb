require 'rails_helper'

feature 'Any driver can create a profile' do

  given(:user) { create(:user, :as_driver, :authorized) }

  background do
    visit new_user_session_path
    login(user) 
  end

  scenario "and fills all fields without errors", js: true do
    visit new_driver_path

    expect(page).to have_content 'Мой профиль'
    expect(page).to have_button 'Принять'
    
    fill_driver_profile

    click_on 'Принять'

    expect(page).to have_content '00 00 123456'
    expect(page).to have_content 'qwerty_001'
    expect(page).to have_content 'Magnitogorsk'
    expect(page).to have_content '2001'
  end

  scenario "or leaves some fields empty", js: true do
    visit new_driver_path

    find('#driver_driver_id').set('')
    find("#driver_region").set('')
    find("#driver_start_driving").set('')

    click_on 'Принять'

    expect(page).to have_content "сохранение не удалось"
    expect(page).to have_content "не может быть пустым"
  end


  scenario "and can't create new profile again", js: true do
    driver = create(:driver, :with_photo, user: user)
    visit new_driver_path

    fill_new_driver_profile

    click_on 'Принять'

    expect(page).to have_content "сохранение не удалось"
    expect(page).to have_content "Учетная запись пользователя уже существует"
  end

end
