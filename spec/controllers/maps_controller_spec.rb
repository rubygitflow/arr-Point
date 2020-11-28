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
end
