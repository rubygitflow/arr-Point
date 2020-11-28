require 'rails_helper'

RSpec.describe LocalesController, type: :controller do
  describe 'Get locale #change' do
    # see only features
    it "responds moved temporarily" do
      get :change
      expect(response.status).to eq(302)
    end
  end
end
