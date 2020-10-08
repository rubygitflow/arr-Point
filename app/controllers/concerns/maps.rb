module Maps
  extend ActiveSupport::Concern

  def store_locale
    # https://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
    cookies[:locale] = {value: I18n.locale.to_s, expires: 7.days.from_now}
  end

  def recover_locale
    I18n.locale = cookies[:locale].to_sym if cookies[:locale]
  end

end
