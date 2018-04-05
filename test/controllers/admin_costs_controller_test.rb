require 'test_helper'

class AdminCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_cost = admin_costs(:one)
  end

  test "should get index" do
    get admin_costs_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_cost_url
    assert_response :success
  end

  test "should create admin_cost" do
    assert_difference('AdminCost.count') do
      post admin_costs_url, params: { admin_cost: { account_id: @admin_cost.account_id, description: @admin_cost.description, flat_fee: @admin_cost.flat_fee, label: @admin_cost.label, percent: @admin_cost.percent } }
    end

    assert_redirected_to admin_cost_url(AdminCost.last)
  end

  test "should show admin_cost" do
    get admin_cost_url(@admin_cost)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_cost_url(@admin_cost)
    assert_response :success
  end

  test "should update admin_cost" do
    patch admin_cost_url(@admin_cost), params: { admin_cost: { account_id: @admin_cost.account_id, description: @admin_cost.description, flat_fee: @admin_cost.flat_fee, label: @admin_cost.label, percent: @admin_cost.percent } }
    assert_redirected_to admin_cost_url(@admin_cost)
  end

  test "should destroy admin_cost" do
    assert_difference('AdminCost.count', -1) do
      delete admin_cost_url(@admin_cost)
    end

    assert_redirected_to admin_costs_url
  end
end
