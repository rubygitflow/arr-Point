require 'uri'

class LocalesController < ApplicationController

  skip_authorization_check :only => [:change]

  def change
    preparing_for_change_language
    if session[:previous_request_url] && 
    session[:previous_request_url] != locales_change_path
      redirect_to session[:previous_request_url]
    else
      redirect_to root_path
    end
  end

  private

  def  preparing_for_change_language
    if session[:previous_request_url]
      u = URI.parse(session[:previous_request_url]).query
      if u
        cgi_params = u.split('&').map { |e| e.split('=') }.to_h
        lang = cgi_params["lang"]
        if lang
          session[:previous_request_url].sub!("lang=#{lang}", '')
        end
      end
    end
    params[:lang] = nil
    session[:locale] = I18n.locale==:en ?  "ru" : "en"
  end

end
