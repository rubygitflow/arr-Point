class SelectDriversService
  include ServicesHelper

  def initialize
  end

  def call
    find_cars
  end

  private

  def find_cars
    # TODO: массив сохранять в REDIS на минуту и загружать данные оттуда, если они ещё там

    @users = User.available_cars
    json_collection.new(@users, each_serializer: UserSerializer)
  end
end
