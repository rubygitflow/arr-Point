require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:car) }
    it { should have_one(:payment) }
  end


  describe 'committing ride statuses' do
    let(:user) { create(:user) }
    let(:car) { create(:car, user: user) }

    it 'chooses default' do
      ride = create(:ride, :schedule, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.scheduled?).to eq(true)
    end

    it 'chooses Execution' do
      ride =  create(:ride, :execute, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.started?).to eq(true)
    end

    it 'chooses Completed' do
      ride =  create(:ride,  :complete, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.completed?).to eq(true)
      expect(ride.finished?).to eq(true)
    end

    it 'chooses Rejected' do
      ride =  create(:ride,  :reject, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.stoped_by_me?).to eq(true)
      expect(ride.finished?).to eq(true)
    end

    it 'chooses Aborted' do
      ride = create(:ride,  :abort, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.stoped_by_client?).to eq(true)
      expect(ride.finished?).to eq(true)
    end
  end

  describe 'Scopes' do
    # https://stackoverflow.com/questions/17817020/testing-default-scope-in-rspec
    let!(:user) { create(:user, :as_driver, :authorized) }
    let!(:car1) { create(:car,  user: user) }
    let!(:rides) { create_list(:ride, 5, car: car1) }
    let!(:car2) { create(:car,  user: user) }
    let!(:ride1) { create(:ride, :complete, car: car2) }
    let!(:ride2) { create(:ride, :complete, car: car2) }
    let!(:payment) { create(:payment, user: user,  ride: ride2) }

    it 'is rides in the processing' do
      expect(Ride.in_processing(car1.id).count).to eq 2
    end

    it 'is all rides with payments statuses' do
      # https://stackoverflow.com/questions/25921007/pgsyntaxerror-error-syntax-error-at-or-near-as-error-rails-4-1
      expect(Ride.with_payments(car2.id).count(:all)).to eq 2
    end
  end
end
