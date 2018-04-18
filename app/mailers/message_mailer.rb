class MessageMailer < ApplicationMailer
  default from: "joe@apexllc.com"

  def contact(message)
    @body = message.body
    @name = message.name
    @phone = message.phone
    @email = message.email

    mail to: "joe@apexllc.com", subject: "New Account Request"
  end
end