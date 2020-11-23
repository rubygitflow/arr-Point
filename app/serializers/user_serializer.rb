class UserSerializer < ActiveModel::Serializer
  attributes %w[id role name phone]
  has_one :driver
  has_many :cars
end
