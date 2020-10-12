require 'rails_helper'

RSpec.describe MapsController, type: :controller do
  describe 'Get #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'recovers a language' do
      # https://relishapp.com/rspec/rspec-rails/v/3-8/docs/controller-specs/cookies
      request.cookies['locale']='en'
      get :index
      expect(I18n.locale).to eq(:en)
    end
  end

  describe 'Get #change_language' do
    it 'redirects to index' do
      get :change_language
      # https://relishapp.com/rspec/rspec-rails/v/4-0/docs/matchers/redirect-to-matcher
      expect(response).to redirect_to action: :index
    end

    it 'changes a language' do
      get :change_language
      expect(I18n.locale.to_s).to_not eq(session[:locale])
      get :index
      expect(I18n.locale.to_s).to eq(session[:locale])
    end
  end
end
