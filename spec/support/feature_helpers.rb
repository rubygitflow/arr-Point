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
end
