class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  include Maps
  before_action :set_locale
  before_action :oathy_confirmation
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :is_root_path?

  def is_root_path?
    self.controller_name == 'maps' && self.action_name == 'index'
  end

  rescue_from CanCan::AccessDenied do |exception|
    if is_navigational_format?
      redirect_to root_url, alert: exception.message
    else
      render json: {errors: exception.message}, status: :forbidden 
    end
  end

  check_authorization unless: :devise_controller?

  private

  def set_locale
    if  params[:lang]
      I18n.locale = I18n.locale_available?(params[:lang]) ? 
                    params[:lang].to_sym : I18n.default_locale
      store_locale 
    elsif session[:locale]
      I18n.locale = I18n.locale_available?(session[:locale]) ? 
                    session[:locale].to_sym : I18n.default_locale
      store_locale 
    else
      recover_locale 
    end
  end

  def oathy_confirmation
    if user_signed_in? && current_user.authy_hook_enabled && 
    current_user.last_sign_in_with_authy
      current_user.authy_hook_turn_off
    else
      if current_user
        if session[:mutable_phone] && session[:mutable_phone] != current_user.phone
          session[:mutable_phone] = current_user.phone
          current_user.authy_hook_turn_on
        end
      end
    end

  end
  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, 
      keys: [:name, :phone, :role, :role_rules_accepted])
    devise_parameter_sanitizer.permit(:account_update, 
      keys: [:name, :phone])
  end

end
