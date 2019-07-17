class TenantMailer < ApplicationMailer
  default from: "hello@ellybilling.app"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tenant_mailer.new_tenant_notification.subject
  #
  def new_tenant_notification(tenant, current_user)
    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/logo.png")
    attachments.inline['facebook@2x.png'] = File.read("#{Rails.root}/app/assets/images/facebook@2x.png")
    attachments.inline['linkedin@2x.png'] = File.read("#{Rails.root}/app/assets/images/linkedin@2x.png")
    attachments.inline['website@2x.png'] = File.read("#{Rails.root}/app/assets/images/website@2x.png")
    attachments.inline['laptop.png'] = File.read("#{Rails.root}/app/assets/images/laptop.png")


    @tenant = tenant
    @user = current_user

    mail to: @tenant.email, subject: "Welcome to Elysium"
  end
end
