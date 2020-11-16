module FeatureHelpers
  def fill_passenger_reg_data
    find('#user_name').set('Don')
    find('#user_phone').set('+71234567890')
    find('#user_role').select('Пассажир')
    find('#user_password').set('12345678')
    find('#user_password_confirmation').set('12345678')
  end

  def fill_driver_reg_data
    find('#user_name').set('Don')
    find('#user_phone').set('+71234567890')
    find("#user_role").select('Водитель')
    find('#user_password').set('12345678')
    find('#user_password_confirmation').set('12345678')
  end

  def login(user)
    find('#user_email').set(user.email)
    find('#user_password').set(user.password)
    click_on 'Войти в аккаунт'
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
