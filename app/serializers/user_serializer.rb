class UserSerializer
  include JSONAPI::Serializer

  attributes :title,
             :description,
             :city,
             :lat,
             :lon
end
