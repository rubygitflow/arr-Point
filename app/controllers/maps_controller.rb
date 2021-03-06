class MapsController < ApplicationController

  before_action :authenticate_user!, except: %i[index]
  before_action :set_gon_reg_users

  skip_authorization_check :only => [:index]

  def index
    if user_signed_in? && 
    current_user.does_hook_before_full_phone_authorization?
      return redirect_to user_enable_authy_path
    elsif user_signed_in? && current_user.is_still_need_phone_authorization?
      return redirect_to user_verify_authy_installation_path
    end
    gon.location_detection_disabled = t('.location_detection_disabled')
  end

  private

  def set_gon_reg_users
    if user_signed_in? && current_user.is_passenger_with_permissions?
      gon.user = current_user.as_json
      gon.drivers = SelectDriversService.new.call
    end
  end
end
