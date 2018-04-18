# Preview all emails at http://localhost:3000/rails/mailers/tenant_mailer
class TenantMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/tenant_mailer/new_tenant_notification
  def new_tenant_notification
    TenantMailer.new_tenant_notification
  end

end
