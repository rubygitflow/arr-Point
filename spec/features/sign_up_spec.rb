require 'rails_helper'

feature 'User can register in the system', %{
  To specify your role in the system,
  confirm your phone number and 
  get access to advanced functionality
} do
  background { visit root_path+'?lang=ru' }

  describe 'The user opens Sign_up page' do
    background { visit new_user_registration_path }

    scenario 'has random Email adress' do
      email = find_field(id: 'user_email').value
      expect(email).not_to eq('')
      expect(email).not_to eq(nil)
    end

    scenario 'and can change it to your email address' do
      find('#user_email').set('new_user_1@test.com')
      click_button 'Создать аккаунт'
      email = find_field(id: 'user_email').value
      expect(email).to eq('new_user_1@test.com')
    end
    # click_on 'Выход'
  end

  describe 'The user registers on the service' do   
    background { visit new_user_registration_path }

    scenario 'with the correct data' do
      fill_passenger_reg_data
      find("#user_role_rules_accepted").set(true)
      click_button 'Создать аккаунт'

      expect(page).to have_content 'Добро пожаловать!'   
      expect(page).to have_content 'Вы успешно зарегистрировались.'      
      # click_on 'Выход'
    end

    scenario 'with an errors' do
      click_button 'Создать аккаунт'
      expect(page).to have_content "Имя не может быть пустым"
      expect(page).to have_content "Пароль не может быть пустым"
      expect(page).to have_content "Номер телефона не может быть пустым"
    end

    scenario 'and fixes an input error' do
      find('#user_email').set('new_user_2@test.com')
      fill_driver_reg_data
      click_button 'Создать аккаунт'
      expect(page).to have_content "Вы должны выразить согласие с Условиями и"

      find('#user_password').set('12345678')
      find('#user_password_confirmation').set('12345678')
      find("#user_role_rules_accepted").set(true)
      click_button 'Создать аккаунт'
      expect(page).to have_content 'Добро пожаловать!'   
      expect(page).to have_content 'Вы успешно зарегистрировались.'      
    end

    scenario 'and will not get access to the map until \
      they pass two-factor authentication' do
      fill_driver_reg_data
      find("#user_role_rules_accepted").set(true)
      click_button 'Создать аккаунт'
      expect(page).not_to have_css('.map')
      expect(page).to have_content 'Активировать аккаунт по номеру телефона'  
    end
  end

  describe 'The new user passes two-factor authentication' do
    given(:user) { create(:user) }
    background do 
      visit new_user_session_path
      login(user)
    end
    
    scenario 'sees his phone number' do
      phone = find_field(id: 'authy-cellphone').value
      phone = PhonyRails.normalize_number(phone)
      expect(user.phone).to eq(phone)
      user_phone_code = PhonyRails.country_code_from_number(user.phone)
      code = find_field(id: "authy-countries").value
      expect(user_phone_code).to eq(code)
    end

    scenario 'can change the phone number', js: true do
      expect(page).to have_css('button')
      expect(page).to have_content 'Принять'  
      find("#authy-cellphone").set('+11234567890')
      # find("#countries-input-0").select('Canada (+1)') - doesn't work
      find("#countries-input-0").click
      # save_and_open_page
      find('li', text: 'Canada (+1)').click
    end

    scenario 'can request the code by SMS to the phone number' do
      click_button 'Принять'
      # save_and_open_page
      expect(page).to have_content 'Подтверждение своего номера телефона' 
      find_link(id: 'authy-request-sms-link').visible?
      expect(page).to have_link(nil, href: '/users/request-sms')
    end
  end
end
