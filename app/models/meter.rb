class Meter < ApplicationRecord
  has_many :records, dependent: :destroy
  belongs_to :site

  require 'csv'

  def self.import_meters(file)
    CSV.foreach(file.path, headers:true) do |row|
      meter = Meter.new row.to_hash
      meter.site_id=1

      if (meter.valid?)
        meter.save
      end
    end
    true
  end

  def import_records(file)
    CSV.foreach(file.path, headers:true) do |row|
      record = Record.new row.to_hash
      self.records << record
    end
    self.last_collection = DateTime.now
    self.save
    true    
  end 

end
