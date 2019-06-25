class TenantFeeSerializer < ActiveModel::Serializer
  attributes :id, :tenant, :amount, :amount, :recurring
end
