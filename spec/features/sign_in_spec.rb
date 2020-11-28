require 'rails_helper'

feature 'User can log in to the system', %{
  To gain access to the extended service menu and 
  so that other service participants can see the user 
  on the interactive map.
} do
  
  given(:user) { create(:user, authy_hook_enabled: false) }
  given(:unconfirmed_user) { create(:user, authy_hook_enabled: true) }
  background do 
    visit root_path+'?lang=ru'
    visit new_user_session_path
  end

  describe 'The user is registered in the system' do
    scenario 'with an UNconfirmed phone number' do
      login(unconfirmed_user)
      expect(page).to have_content 'Активировать учётную запись по номеру телефона'
    end

    scenario 'with the confirmed phone number' do
      login(user)
      expect(page).to have_css('.map')
      expect(page).to have_content 'Учётная запись активирована.'
    end
  end

  scenario 'An unregistered user is trying to log in' do
    find('#user_email').set('wrong@test.com')
    find('#user_password').set('12345678')
    click_on 'Войти в личный кабинет'
    expect(page).to have_content 'Неверный Email или пароль.'
  end
end
