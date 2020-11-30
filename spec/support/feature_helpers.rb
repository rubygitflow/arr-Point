module FeatureHelpers
  def fill_passenger_reg_data
    find('#user_email').set('qwerty.passenger@mail.com')
    find('#user_name').set('Don')
    find('#user_phone').set('+71234567890')
    # https://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FNode%2FActions:choose
    find('#user_passenger').choose()
    find('#user_password').set('12345678')
    find('#user_password_confirmation').set('12345678')
  end

  def fill_driver_reg_data
    find('#user_email').set('qwerty.driver@mail.com')
    find('#user_name').set('Don')
    find('#user_phone').set('+71234567890')
    # https://www.rubydoc.info/github/jnicklas/capybara/Capybara%2FNode%2FActions:choose
    find("#user_driver").choose()
    find('#user_password').set('12345678')
    find('#user_password_confirmation').set('12345678')
  end

  def login(user)
    find('#user_email').set(user.email)
    find('#user_password').set(user.password)
    click_on 'Войти в личный кабинет'
  end

  def logout(user)
    click_on 'Выйти'
  end

  def fill_driver_profile
    attach_file 'Фотография', "#{Rails.root}/spec/fixtures/files/example1.jpg"
    find('#driver_driver_id').set('00 00 123456')
    find('#driver_license_id').set('qwerty_001')
    find("#driver_region").set('Magnitogorsk')
    find('#driver_start_driving').set(2001)
  end

  def fill_new_driver_profile
    attach_file 'Фотография', "#{Rails.root}/spec/fixtures/files/example2.jpg"
    find('#driver_driver_id').set('99 99 000111')
    find('#driver_license_id').set('party_001')
    find("#driver_region").set('Dubki')
    find('#driver_start_driving').set(1980)
  end
end
