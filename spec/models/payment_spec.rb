require 'rails_helper'

RSpec.describe Payment, type: :model do

  describe 'associations' do
    # http://matchers.shoulda.io/docs/v4.3.0/Shoulda/Matchers/ActiveRecord.html#have_many-instance_method
    it { should belong_to(:user) }
    it { should belong_to(:ride) }
  end
end
