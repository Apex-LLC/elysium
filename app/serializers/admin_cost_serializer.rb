class AdminCostSerializer < ActiveModel::Serializer
  attributes :id, :label, :description, :percent, :flat_fee
  has_one :account
end
