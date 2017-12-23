class BillableMeter < ApplicationRecord
  belongs_to :meter
  belongs_to :tenant
end
