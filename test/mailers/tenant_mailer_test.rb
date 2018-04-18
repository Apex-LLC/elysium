require 'test_helper'

class TenantMailerTest < ActionMailer::TestCase
  test "new_tenant_notification" do
    mail = TenantMailer.new_tenant_notification
    assert_equal "New tenant notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
