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
    successful=0
    unsuccessful=0

    CSV.foreach(file.path, headers:true) do |row|
      record = Record.new row.to_hash
      record.meter = self

      if (record.valid? && !self.records.where(datetime: record.datetime).exists?)
        self.records << record
        logger.info "NEW RECORD ADDED: " + row.to_hash.to_s
        successful+=1
      else
        logger.info "RECORD SKIPPED: " + record.errors.full_messages.to_sentence
        unsuccessful+=1
      end

    end
    
    self.last_collection = DateTime.now
    self.save

    logger.info "Successfully added " + successful.to_s + " records. " + unsuccessful.to_s + " records were not added."
    true    
  end 

end
