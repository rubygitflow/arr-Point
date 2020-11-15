require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  

  describe "GET #splitter" do
    context 'new driver' do
      let(:new_driver) { create(:user, :as_driver, :authorized) }

      it "redirects to new driver page" do
        login(new_driver)
        get :splitter
        expect(response).to redirect_to new_driver_path
      end
    end

    context 'old driver' do
      let(:old_driver) { create(:user, :as_driver, :authorized) }

      it "redirects to driver's show page" do
        login(old_driver)
        driver_details = create(:driver, user: old_driver)
        get :splitter
        # https://relishapp.com/rspec/rspec-rails/docs/matchers/redirect-to-matcher
        expect(response).to redirect_to action: :show, id: driver_details.id
      end
    end
  end

  describe "GET #index" do
    context 'admin can read this page' do
      let(:administrator) { create(:user, :admin, :authorized) }

      it "returns http success" do
        login(administrator)
        get :index
        # https://relishapp.com/rspec/rspec-rails/docs/matchers/have-http-status-matcher
        expect(response).to have_http_status(:success)
      end
    end 
    context "non-admin can't read this page" do
      let(:not_an_administrator) { create(:user, :not_an_admin, :authorized) }

      it "returns http redirection" do
        login(not_an_administrator)
        get :index
        # https://relishapp.com/rspec/rspec-rails/docs/matchers/have-http-status-matcher
        expect(response).to have_http_status(302)
      end
    end 
  end

  describe "GET #show" do
    let!(:old_driver) { create(:user, :as_driver, :authorized) }
    before do 
      login(old_driver)
      profile = create(:driver, user: old_driver)
      get :show, params: { id: profile }
    end

    it 'assigns the requested old_driver to @driver' do
      expect(assigns(:old_driver)).to eq @driver
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    let!(:new_driver) { create(:user, :as_driver, :authorized) }
    before do 
      login(new_driver)
      get :new
    end

    it 'assigns a new_driver to @driver' do
      expect(assigns(:new_driver)).to eq @driver
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    let!(:old_driver) { create(:user, :as_driver, :authorized) }
    before do 
      login(old_driver)
      profile = create(:driver, user: old_driver)
      get :edit, params: { id: profile }
    end

    it 'assigns the requested old_driver to @driver' do
      expect(assigns(:old_driver)).to eq @driver
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    let!(:new_driver) { create(:user, :as_driver, :authorized) }
    before do 
      login(new_driver)
    end

    context 'with valid attributes' do
      it 'saves a driver details in the database' do
        expect { post :create, params: { driver: attributes_for(:driver) },
               format: :js  }.to change(Driver, :count).by(1)
      end

      it 'authenticated new_driver to be owner of his details' do
        post :create, params: {driver: attributes_for(:driver)}, format: :js  
        expect(new_driver).to be_owner(assigns(:driver))
      end

      it 'redirects to show' do
        post :create, params: { driver: attributes_for(:driver) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the driver details' do
        expect { post :create, 
          params: { driver: attributes_for(:driver, :invalid) }, format: :js 
                  }.to_not change(Driver, :count)
      end

      it 're-renders new view' do
        post :create, params: { driver: attributes_for(:driver, :invalid) },
          format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe "PATCH #update" do
    context 'with valid attributes' do

      it 'assigns the requested old_driver to @driver' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        patch :update, params: { id: profile, driver: attributes_for(:driver) }, format: :js
        expect(assigns(:old_driver)).to eq @driver
      end

      it 'changes driver attributes' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        patch :update, params: { id: profile, driver: {driver_id: '77 77 9999'} }, format: :js
        profile.reload
        expect(profile.driver_id).to eq '77 77 9999'
      end

      it "renders updated driver's view" do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        patch :update, params: { id: profile, driver: attributes_for(:driver) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not change driver details' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        patch :update, params: {id: profile, driver: attributes_for(:driver, :invalid)}, format: :js 
        profile.reload       
        expect(profile.driver_id).to_not eq nil
      end

      it "renders driver's update view" do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        patch :update, params: {id: profile, driver: attributes_for(:driver, :invalid)}, format: :js 
        expect(response).to render_template :update
      end
    end
    
    context 'with incorrect user' do
      it 'does not change driver details' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        # profile.user = create(:driver)
        # profile.save!
        old_driver_id = profile.driver_id
        patch :update, params: { id: profile, driver: { driver_id: '' }, format: :js }
        profile.reload
        expect(profile.driver_id).to eq old_driver_id
      end
    end
  end

  describe "DELETE #destroy" do
    context 'author' do
      it 'deletes the question' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        expect { delete :destroy, params: { id: profile } }.to change(Driver, :count).by(-1)
      end

      it 'redirects to account page' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        delete :destroy, params: { id: profile }
        expect(response).to redirect_to edit_user_registration_path
      end
    end

    context 'not author' do
      it "doesn't delete the question" do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        other_profile = create(:driver)
        expect { delete :destroy, params: { id: other_profile } }.to_not change(Driver, :count)
      end

      it 'redirects to root' do
        driver = create(:user, :as_driver, :authorized) 
        login(driver)
        profile = create(:driver, user: driver)
        other_profile = create(:driver)
        delete :destroy, params: { id: other_profile }
        expect(response).to redirect_to root_path
      end
    end
  end

end
