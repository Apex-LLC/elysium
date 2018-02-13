class Api::V1::BillableMeterSerializer < Api::V1::BaseSerializer
  attributes :id, :created_at, :updated_at

  belongs_to :meter

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end