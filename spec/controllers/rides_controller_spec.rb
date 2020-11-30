require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  let(:driver) { create(:user, :as_driver, :authorized) }
  let(:other_driver) { create(:user, :as_driver, :authorized) }
  let(:admin) { create(:user, :admin, :authorized) }
  let(:car1) { create(:car,  user: driver) }
  let(:car2) { create(:car,  user: other_driver) }
  let(:rides1) { create_list(:ride, 5, car: car1) }

  before(:each) do 
    login(driver)
  end

  describe 'GET #menu' do
    # https://github.com/rspec/rspec-rails/issues/1767
    # https://stackoverflow.com/questions/32320214/actioncontrollerurlgenerationerror-no-route-matches
    before do 
      get :menu , params: { use_route: 'cars/:car_id/rides/', car_id: car1.id }
    end

    it 'populates an array of non-completed rides' do
      expect(assigns(:rides)).to_not match_array(rides1)
      # https://stackoverflow.com/questions/47778983/rspec-check-the-count-of-an-array
      expect(assigns(:rides).count).to eq 2
    end

    it 'renders menu view' do
      expect(response).to render_template :menu
    end
  end

  describe 'GET #index' do
    before do 
      get :index , params: { use_route: 'cars/:car_id/rides/', car_id: car1.id }
    end

    it 'populates an array of all rides' do
      expect(assigns(:rides_payments)).to_not eql(rides1)
      # https://stackoverflow.com/questions/25921007/pgsyntaxerror-error-syntax-error-at-or-near-as-error-rails-4-1
      expect(assigns(:rides_payments).count(:all)).to eq 5

    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'POST #complete' do
    let(:ride1) { create(:ride, :execute , car: car1) }
    let(:ride2) { create(:ride, :complete , car: car1) }
    let(:ride3) { create(:ride, :abort , car: car1) }

    it "responds moved temporarily for active ride" do
      post :complete, params: { use_route: '/rides/:id/complete', id: ride1.id } 
      expect(response.status).to eq(302)
    end

    it "responds moved temporarily for completed ride" do
      post :complete, params: { use_route: '/rides/:id/complete', id: ride2.id } 
      expect(response.status).to eq(302)
    end

    it "responds moved temporarily for aborted ride" do
      post :complete, params: { use_route: '/rides/:id/complete', id: ride3.id } 
      expect(response.status).to eq(302)
    end
  end


  describe 'POST #create' do
    it 'saves a ride description in the database only for driver with car' do
      expect { post :create, params: { car_id: car1, 
        ride: attributes_for(:ride) }, format: :js  }.to change(Ride, :count).by(1)
    end

    it 'allways can be done' do
      post :create, params: { car_id: car1, ride: attributes_for(:ride) }, 
        format: :js
      expect(response.status).to eq(200)
    end

    it 'renders create template' do
      post :create, params: { car_id: car1, ride: attributes_for(:ride) }, 
        format: :js
      expect(response).to render_template :create
    end
  end

  describe 'PATCH #update' do
    it 'assigns requested ride to @ride' do
      ride4 = create(:ride, car: car1) 
      patch :update, params: { id: ride4, ride: {cost: 123.45}, format: :js }
      expect(assigns(:ride)).to eq ride4
    end

    it 'changes car attributes' do
      ride4 = create(:ride, car: car1) 
      patch :update, params: { id: ride4, ride: {cost: 123.45}, format: :js }
      ride4.reload
      expect(ride4.cost).to eq 123.45
    end

    it "renders updated car's view" do
      ride4 = create(:ride, car: car1) 
      patch :update, params: { id: ride4, ride: {cost: 123.45}, format: :js }
      expect(response).to render_template :update
    end

    it "someone else excluding the administrator can not change route description" do
      ride4 = create(:ride, car: car1) 
      logout(driver)

      login(other_driver)
      patch :update, params: {id: ride4, ride: {cost: 123.45}, format: :js}
      expect(response).to be_forbidden
    end

    it "administrator changes route description" do
      ride6 = create(:ride, car: car1)
      logout(driver)

      login(admin)
      patch :update, params: {id: ride6, ride: {cost: 123.45}, format: :js}
      ride6.reload # important
      expect(response).to render_template :update
      expect(ride6.cost).to eq 123.45
    end
  end

  describe 'PATCH #execute' do
    let(:ride4) { create(:ride, car: car1) }
    before do 
      patch :execute, params: { id: ride4}
    end

    it "responds moved temporarily" do
      expect(response.status).to eq(302)
    end

    it 'changes car attributes' do
      ride4.reload
      expect(ride4.status).to eq 'Execution'
    end
  end


  describe 'PATCH #abort' do
    let(:ride4) { create(:ride, car: car1) }
    before do 
      patch :abort, params: { id: ride4}
    end

    it "responds moved temporarily" do
      expect(response.status).to eq(302)
    end

    it 'changes car attributes' do
      ride4.reload
      expect(ride4.status).to eq 'Aborted'
    end
  end

  describe 'PATCH #reject' do
    let(:ride4) { create(:ride, car: car1) }
    before do 
      patch :reject, params: { id: ride4}
    end

    it "responds moved temporarily" do
      expect(response.status).to eq(302)
    end

    it 'changes car attributes' do
      ride4.reload
      expect(ride4.status).to eq 'Rejected'
    end
  end

  describe 'DELETE #destroy' do

    context 'owner' do
      it 'deletes the ride' do
        driver9= create(:user, :as_driver, :authorized)
        login(driver9)
        car9 = create(:car,  user: driver9)
        ride9 = create(:ride, :schedule, car: car9)
        expect { delete :destroy, params: { id: ride9 }, 
          format: :js }.to change(Ride, :count).by(-1)
      end

      it 'renders destroy view' do
        driver10= create(:user, :as_driver, :authorized)
        login(driver10)
        car10 = create(:car,  user: driver10)
        ride10 = create(:ride, :schedule, car: car10)
        delete :destroy, params: {id: ride10, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not owner' do
      it "doesn't delete the ride" do
        driver8= create(:user, :as_driver, :authorized)
        login(driver8)
        car8 = create(:car,  user: driver8)
        ride8 = create(:ride, :schedule, car: car8)
        logout(driver8)
        login(other_driver)
        expect { delete :destroy, params: {id: ride8}, 
          format: :js }.to_not change(Ride, :count)
      end


      it "someone else excluding the administrator can not delete route description" do
        driver11= create(:user, :as_driver, :authorized)
        login(driver11)
        car11 = create(:car,  user: driver11)
        ride11 = create(:ride, :schedule, car: car11)
        logout(driver11)
        login(other_driver)
        delete :destroy, params: {id: ride11, format: :js}
        expect(response).to be_forbidden
      end

      it "administrator deletes route description" do
        driver7 = create(:user, :as_driver, :authorized)
        admin7 = create(:user, :admin, :authorized)
        login(driver7)
        car7 = create(:car,  user: driver7)
        ride7 = create(:ride, :schedule, car: car7)

        logout(driver7)
        login(admin7)
        patch :destroy, params: {id: ride7, format: :js}
        expect(response).to render_template :destroy
      end
    end
  end

end
