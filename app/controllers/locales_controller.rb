class LocalesController < ApplicationController

  skip_authorization_check :only => [:change]

  def change
    session[:locale] = I18n.locale==:en ?  "ru" : "en"
    redirect_to session[:previous_request_url]
  end
end
