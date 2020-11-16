require 'rails_helper'

feature 'User can edit his personal data', %{
  To change his registration data or remove his account.
} do
  # https://devhints.io/capybara

  given(:user) { create(:user, authy_hook_enabled: true) } 
  given(:registered_user) { create(:user, 
    authy_hook_enabled: true,
    authy_id: 321,
    last_sign_in_with_authy: '2020-11-07 15:45:36') } 

  given(:reg_driver) { create(:user, :as_driver,  :not_an_admin, :authorized) } 
  given(:reg_admin) { create(:user, :as_driver, :admin, :authorized) } 
   
  background { visit root_path+'?lang=ru' }

  scenario "The gest couldn't open edit account page" do
    visit edit_user_registration_path 
    expect(page).to have_content 'Вход в систему'   
  end

  scenario 'An authenticated user can open edit page'  do

    visit new_user_session_path
    login(registered_user)
    visit root_path
    # save_and_open_page

    find(".menu-map").click
    find_link('Личный кабинет', visible: :all).click
    expect(page).to have_content 'Обновить'
  end


  describe 'An authenticated user can edit his registration data' do  
    background do
      visit new_user_session_path
      login(user)
      visit edit_user_registration_path 
    end

    scenario 'with the correct data'  do
      find('#user_name').set('Don')
      find('#user_phone').set('+71234567890')
      find('#user_password').set('123456')
      find('#user_password_confirmation').set('123456')

      expect(page).not_to have_css('#user_role')

      find('#user_current_password').set('12345678')

      click_button 'Обновить'
      # save_and_open_page

      expect(page).to have_content 'Ваша учётная запись успешно изменена.'
      expect(page).to have_content 'Активировать аккаунт по номеру телефона'
    end

    scenario "but couldn't delete name" do
      find('#user_name').set('')
      find('#user_current_password').set('12345678')

      click_button 'Обновить'

      expect(page).to have_content "Имя не может быть пустым"
    end

    scenario "and couldn't delete phone" do
      find('#user_phone').set('')
      find('#user_current_password').set('12345678')

      click_button 'Обновить'

      expect(page).to have_content "Номер телефона не может быть пустым"
    end

    scenario "or can remove his account" do

      click_button 'Удалить'

      # # accept_alert do
      # # page.driver.browser.switch_to.alert.accept do
      # # accept_confirm do
      # # accept_modal do
      # accept_alert do  
      #   click_link 'OK'
      # end
      # # Capybara::NotSupportedByDriverError:
      # #   Capybara::Driver::Base#accept_modal

      # IT WORKS WITHOUT accept_alert 
      # save_and_open_page

      expect(page).to have_content 'Ваша учётная запись успешно удалена.'
      expect(page).to have_css('.map')
    end
  end

  describe 'An registered driver' do  
    background do
      visit new_user_session_path
      login(reg_driver)
      visit edit_user_registration_path 
    end
    scenario "can add his profile on the first visit" do
      click_link 'Профиль'

      expect(page).to have_content 'Мой профиль'
      # save_and_open_page
      expect(page).to have_button 'Принять'
    end

    scenario "can visit his profile on the next time" do
      driver = create(:driver, user: reg_driver)
      click_link 'Профиль'

      # save_and_open_page
      expect(page).to have_content 'Мой профиль'
      expect(page).to have_link 'Отредактировать профиль'
    end
  end

  describe 'The registered admin' do  
    background do
      visit new_user_session_path
      login(reg_admin)
      visit edit_user_registration_path 
    end
    scenario "can visit Roster of drivers page" do
      driver = create(:driver, user: reg_admin)
      expect(page).to have_link 'Список водителей'
      click_link 'Список водителей'

      # save_and_open_page
      expect(page).to have_content 'Водители'
      expect(page).to have_link '>>>'
    end
  end
end
