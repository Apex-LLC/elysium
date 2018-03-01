class RateSerializer < ActiveModel::Serializer
  attributes :id, :symbol, :rate, :description
  has_one :user
end
