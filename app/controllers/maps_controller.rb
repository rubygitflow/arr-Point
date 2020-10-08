class MapsController < ApplicationController
  include Maps

  before_action :recover_locale, except: %i[change_language]

  def index
  end

  def change_language
    session[:lang] = I18n.locale==:en ?  "ru" : "en"
    return redirect_to maps_path
  end

end
