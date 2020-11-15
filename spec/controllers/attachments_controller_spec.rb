require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user, :as_driver, :authorized) }
  let!(:driver) { create(:driver, user: user) }
  let(:other_user) { create(:user, :as_driver, :authorized) }
  let!(:other_driver) { create(:driver, user: other_user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'owner of the attachment' do
      before do
        driver.photo.attach(create_file_blob) 
      end

      it "deletes the photo from the driver's profile" do
        # https://relishapp.com/rspec/rspec-rails/v/4-0/docs/routing-specs
        expect(:delete => "/drivers/"+driver.photo.id.to_s).to be_routable
      end

      it "renders the destroy view by driver's profile" do
        delete :destroy, params: {id: driver.photo.id}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not the owner of the attachment' do
      before do 
        other_driver.photo.attach(create_file_blob) 
      end

      it "returns forbidden status after edition of other driver's profile" do
        delete :destroy, params: {id: other_driver.photo.id}, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
