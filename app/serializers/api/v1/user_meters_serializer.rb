class Api::V1::UserMetersSerializer < Api::V1::BaseSerializer
  attributes :meters

  def meters
    billable_meters = []
    tenants = object.tenants
    tenants.each do |t|
      t.billable_meters.each do |b|
        billable_meters << b.meter.reference
      end
    end
    return billable_meters
  end

  def created_at
    object.created_at.in_time_zone.iso8601 if object.created_at
  end

  def updated_at
    object.updated_at.in_time_zone.iso8601 if object.created_at
  end
end