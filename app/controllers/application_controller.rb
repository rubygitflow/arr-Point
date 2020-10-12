class ApplicationController < ActionController::Base
  include Maps
  before_action :set_locale

  private

  def set_locale
    if params[:lang]
      I18n.locale = I18n.locale_available?(params[:lang]) ? params[:lang].to_sym : I18n.default_locale
      store_locale 
    elsif session[:locale]
      I18n.locale = I18n.locale_available?(session[:locale]) ? session[:locale].to_sym : I18n.default_locale
      store_locale 
    else
      recover_locale
    end
  end
end
