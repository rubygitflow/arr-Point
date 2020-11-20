require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do

  describe "GET #accept" do
    it "returns http success" do
      get :accept
      expect(response).to have_http_status(:success)
    end
  end

end
