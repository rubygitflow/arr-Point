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
      ride = create(:ride, car: car) 
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
      puts("ride.status=#{ride.status}")
      expect(ride.finished?).to eq(true)
    end

    it 'chooses Rejected' do
      ride =  create(:ride,  :reject, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.stoped_by_me?).to eq(true)
      puts("ride.status=#{ride.status}")
      expect(ride.finished?).to eq(true)
    end

    it 'chooses Aborted' do
      ride = create(:ride,  :abort, car: car) 
      expect(Ride.count).to eq 1
      expect(ride.stoped_by_client?).to eq(true)
      puts("ride.status=#{ride.status}")
      expect(ride.finished?).to eq(true)
    end
  end
end
