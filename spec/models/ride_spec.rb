require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:car) }
    it { should have_one(:payment) }
  end
end
