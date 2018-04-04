class AddAttachmentLogoToTenants < ActiveRecord::Migration[5.1]
  def self.up
    change_table :tenants do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :tenants, :logo
  end
end
