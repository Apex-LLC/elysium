class Api::V1::TenantSerializer < Api::V1::BaseSerializer
  attributes :name, :email, :billable_meters, :created_at, :updated_at

  has_many :billable_meters



  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end