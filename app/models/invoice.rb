class Invoice < ApplicationRecord
  belongs_to :tenant

  def readable_date
    formatted_start_date=self.start_date.strftime("%B #{self.start_date.day.ordinalize}")
    formatted_end_date=self.end_date.strftime("%B #{self.end_date.day.ordinalize}")
    return formatted_start_date + " - " + formatted_end_date
  end

end
