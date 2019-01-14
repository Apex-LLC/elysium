class Meter < ApplicationRecord
  has_many :records, dependent: :destroy
  belongs_to :site
  validates_uniqueness_of :reference, :scope => [:site_id]

  require 'csv'

  def self.import_meters(file,site_id)
    CSV.foreach(file.path, headers:true) do |row|
      meter = Meter.new row.to_hash

      meter.site_id=site_id

      if (meter.valid?)
        meter.save
      end
    end
    true
  end

  def import_records(file)
    logger.info "Importing records for [" + self.reference + "]..."
    CSV.foreach(file.path, headers:true) do |row|
      record = self.records.new row.to_hash
      logger.info "  - [" + record.datetime.to_s + "," + record.value.to_s + "]"
      if (record.valid?)
        self.records << record
      end
    end
    self.last_collection = DateTime.now
    self.save
    true    
  end 

end
