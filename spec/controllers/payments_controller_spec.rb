require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  # https://askdev.ru/q/kak-obyavit-peremennuyu-razdelyaemuyu-mezhdu-primerami-v-rspec-109644/
  before(:each) do 
    @driver= create(:user, :as_driver, :authorized)
    login(@driver)
    car = create(:car,  user: @driver)
    @ride = create(:ride,  car: car)
  end
  
  describe "GET #accept" do
    context "be incorrect http-params" do
      before do 
        get :accept 
      end

      it "returns http success" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "be correct http-params" do
      # before do 
      #   get :accept,  :params => { :pc => '12345' }
      # end

      # it "returns http success" do
      #   expect(response).to have_http_status(:success)
      # end

      # it 'renders accept view' do
      #   expect(response).to render_template :accept
      # end
    end 
  end
  
  describe "PATCH #pay_off" do
    before(:each) do 
      @payment = create(:payment,  user: @driver,  ride: @ride)
    end

    context 'applicable for admin' do
      before(:each) do 
        logout(@driver)
        admin = create(:user, :admin, :authorized)
        login(admin)
      end

      it 'assigns requested payment to @payment' do
        patch :pay_off, params: { id: @payment, format: :js }
        expect(assigns(:payment)).to eq @payment
      end

      it 'renders pay_off view' do
        patch :pay_off, params: { id: @payment, format: :js }
        expect(response).to render_template :pay_off
      end

      it 'changes payment attribute' do
        expect(@payment.paid_up).to eq nil
        patch :pay_off, params: { id: @payment, format: :js }
        @payment.reload
        expect(@payment.paid_up).to_not eq nil
      end
    end 

    context 'not applicable for driver' do
      it 'forbidden to payment' do
        patch :pay_off, params: { id: @payment, format: :js }
        expect(response).to be_forbidden
      end
    end 
  end
end
