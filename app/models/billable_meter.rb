class BillableMeter < ApplicationRecord
  belongs_to :meter
  belongs_to :tenant
  before_save :set_percent_allocation

  private
    def set_percent_allocation      
      self.percent_allocation = 100 if self.percent_allocation.blank?
    end
end
