module ServicesHelper
  def json_collection
    ActiveModel::Serializer::CollectionSerializer
  end
end
