require 'rails_helper'

RSpec.describe Payment, type: :model do

  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:user) }
    it { should belong_to(:ride) }
  end


  describe '#to_pay!' do
    let(:user) { create(:user) }
    let(:car) { create(:car, user: user) }
    let(:ride) { create(:ride, :complete, car: car) }


    it 'has accepted payment' do
    	payment = create(:payment, ride: ride, user: user) 

      expect(payment.paid_up).to eq(nil) 
      payment.to_pay!
      expect(payment.paid_up).to_not eq(nil) 
    end
  end

end
