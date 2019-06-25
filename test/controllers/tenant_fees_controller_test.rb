require 'test_helper'

class TenantFeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tenant_fee = tenant_fees(:one)
  end

  test "should get index" do
    get tenant_fees_url
    assert_response :success
  end

  test "should get new" do
    get new_tenant_fee_url
    assert_response :success
  end

  test "should create tenant_fee" do
    assert_difference('TenantFee.count') do
      post tenant_fees_url, params: { tenant_fee: { amount: @tenant_fee.amount, amount: @tenant_fee.amount, recurring: @tenant_fee.recurring, tenant: @tenant_fee.tenant } }
    end

    assert_redirected_to tenant_fee_url(TenantFee.last)
  end

  test "should show tenant_fee" do
    get tenant_fee_url(@tenant_fee)
    assert_response :success
  end

  test "should get edit" do
    get edit_tenant_fee_url(@tenant_fee)
    assert_response :success
  end

  test "should update tenant_fee" do
    patch tenant_fee_url(@tenant_fee), params: { tenant_fee: { amount: @tenant_fee.amount, amount: @tenant_fee.amount, recurring: @tenant_fee.recurring, tenant: @tenant_fee.tenant } }
    assert_redirected_to tenant_fee_url(@tenant_fee)
  end

  test "should destroy tenant_fee" do
    assert_difference('TenantFee.count', -1) do
      delete tenant_fee_url(@tenant_fee)
    end

    assert_redirected_to tenant_fees_url
  end
end
