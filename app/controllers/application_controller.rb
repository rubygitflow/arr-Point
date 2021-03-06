class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception, prepend: true

  before_action :set_locale
  before_action :oathy_confirmation
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_back_url

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

  def back_url
    if session[:previous_request_url]
      session[:previous_request_url]
    else
      root_url
    end
  end

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
    if user_signed_in? 
      if current_user.finished_phone_authorization?
        current_user.authy_hook_turn_off
      elsif session[:mutable_phone] && session[:mutable_phone] != current_user.phone
        session[:mutable_phone] = current_user.phone
        current_user.authy_hook_turn_on
      end
    end

  end

  def store_back_url
    # Pattern matching is experimental, and the behavior may change in future versions of Ruby
    if are_available_routes?
      session[:previous_request_url] = request.url  
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, 
      keys: [:name, :phone, :role, :role_rules_accepted])
    devise_parameter_sanitizer.permit(:account_update, 
      keys: [:name, :phone])
  end

  def are_available_routes?
    request.get? && 
    self.controller_name != "locales" && 
    self.action_name != 'accept'
  end

  def store_locale
    # https://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
    cookies[:locale] = {value: I18n.locale.to_s, expires: 7.days.from_now}
  end

  def recover_locale
    I18n.locale = cookies[:locale].to_sym if cookies[:locale]
  end
end
