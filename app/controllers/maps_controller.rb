class MapsController < ApplicationController
  include Maps

  def index
  end

  def change_language
    session[:locale] = I18n.locale==:en ?  "ru" : "en"
    return redirect_to root_path
  end

end
