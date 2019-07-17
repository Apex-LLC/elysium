class TenantMailer < ApplicationMailer
  default from: "hello@ellybilling.app"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tenant_mailer.new_tenant_notification.subject
  #
  def new_tenant_notification(tenant, current_user)
    @tenant = tenant
    @user = current_user

    mail to: @tenant.email, subject: "Welcome to Elysium"
  end
end
