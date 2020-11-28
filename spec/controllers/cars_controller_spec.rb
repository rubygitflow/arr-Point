require 'rails_helper'

RSpec.describe CarsController, type: :controller do
  
  let(:administrator) { create(:user, :admin, :authorized) }
  let(:driver) { create(:user, :as_driver, :authorized) }
  let(:other_driver) { create(:user, :as_driver, :authorized) }
  let(:passager) { create(:user, :as_passager, :authorized) }

  let(:car) { create(:car,  user: driver) }
  let(:other_car) { create(:car,  user: driver) }

  describe 'POST #create' do
    before { login(driver) } 

    context 'with valid attributes' do
      it 'saves a car description in the database only for driver with profile' do
        profile = create(:driver, user: driver)
        expect { post :create, params: { driver_id: profile, 
          car: attributes_for(:car) }, format: :js  }.to change(Car, :count).by(1)
      end

      it 'authorized driver must be the owner of the car' do
        profile = create(:driver, user: driver)
        post :create, params: { driver_id: profile, car: attributes_for(:car) }, 
          format: :js
        expect(driver).to be_owner(assigns(:car))
      end

      it 'renders create template' do
        profile = create(:driver, user: driver)
        post :create, params: { driver_id: profile, car: attributes_for(:car) }, 
          format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the car description' do
        profile = create(:driver, user: driver)
        expect { post :create, params: { driver_id: profile, 
                car: attributes_for(:car, :invalid) }, 
               format: :js }.to_not change(Car, :count)
      end

      it 'renders create template' do
        profile = create(:driver, user: driver)
        post :create, params: { driver_id: profile, 
          car: attributes_for(:car, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(driver) }

    context 'with valid attributes' do
      it 'assigns requested car to @car' do
        patch :update, params: { id: car, car: {license_plate: '12345678'} }, 
          format: :js
        expect(assigns(:car)).to eq car
      end

      it 'changes car attributes' do
        patch :update, params: { id: car, car: {license_plate: '12345678'} }, 
          format: :js
        car.reload
        expect(car.license_plate).to eq '12345678'
      end

      it "renders updated car's view" do
        patch :update, params: { id: car, car: {license_plate: '12345678'} }, 
          format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change car attributes' do
        patch :update, params: {id: car, 
            car: attributes_for(:car, :invalid)}, format: :js
        car.reload
        expect(car.license_plate).to eq 'С123МВ 77'
      end

      it 'returns forbidden' do
        logout(driver)
        login(other_driver)
        patch :update, params: {id: other_car, format: :js}
        expect(response).to be_forbidden
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(driver) }

    context 'owner' do
      it 'deletes the car' do
        driver1= create(:user, :as_driver, :authorized)
        login(driver1)
        car1 = create(:car,  user: driver1)
        expect { delete :destroy, params: { id: car1 }, format: :js }.to change(Car, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: {id: car, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context 'not owner' do
      it "doesn't delete the car" do
        driver2= create(:user, :as_driver, :authorized)
        login(driver2)
        other_car2 = create(:car,  user: driver2)
        logout(driver2)
        login(other_driver)
        expect { delete :destroy, params: {id: other_car2}, format: :js }.to_not change(Car, :count)
      end

      it 'returns forbidden' do
        logout(driver)
        login(other_driver)
        delete :destroy, params: {id: other_car}, format: :js
        expect(response).to be_forbidden
      end
    end
  end

  describe 'POST #select_workhorse' do

    context 'admin' do
      before do 
        login(administrator)
        post :select_workhorse, params: {id: car, format: :js} 
      end

      it 'assigns the requested car to @car' do
        expect(assigns(:car)).to eq car
      end

      it 'update workhorse attribute' do
        car.reload
        expect(car.workhorse).to eq true
      end

      it 'render select_workhorse template' do
        expect(response).to render_template :select_workhorse
      end
    end

    context 'not an admin' do
      context 'as driver' do
        before do 
          login(driver)
          post :select_workhorse, params: {id: car, format: :js} 
        end

        it 'assigns the requested car to @car' do
          expect(assigns(:car)).to eq car
        end

        it 'update workhorse attribute' do
          car.reload
          expect(car.workhorse).to eq true
        end

        it 'render select_workhorse template' do
          expect(response).to render_template :select_workhorse
        end
      end 

      context 'as other driver' do
        before do 
          login(other_driver)
          post :select_workhorse, params: {id: car, format: :js} 
        end

        it 'do not update workhorse attribute' do
          car.reload
          expect(car.workhorse).to_not eq true
        end

        it 'returns forbidden' do
          expect(response).to be_forbidden
        end
      end 

      context 'as passager' do
        before do 
          login(passager)
          post :select_workhorse, params: {id: car, format: :js} 
        end

        it 'not update workhorse attribute' do
          car.reload
          expect(car.workhorse).to_not eq true
        end

        it 'returns forbidden' do
          expect(response).to be_forbidden
        end
      end 
    end
  end
end
