class MapsController < ApplicationController
  include Maps

  before_action :authenticate_user!, except: %i[index change_language]

  def index
    if user_signed_in? && current_user.authy_enabled && 
    !current_user.authy_id && !current_user.last_sign_in_with_authy
      redirect_to user_enable_authy_path
    elsif user_signed_in? && current_user.authy_enabled && 
    current_user.authy_id && !current_user.last_sign_in_with_authy
      current_user.authy_turn_off 
      redirect_to user_verify_authy_installation_path
    end
  end

  def change_language
    session[:locale] = I18n.locale==:en ?  "ru" : "en"
    return redirect_to root_path
  end

end
