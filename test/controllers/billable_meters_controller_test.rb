require 'test_helper'

class BillableMetersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @billable_meter = billable_meters(:one)
  end

  test "should get index" do
    get billable_meters_url
    assert_response :success
  end

  test "should get new" do
    get new_billable_meter_url
    assert_response :success
  end

  test "should create billable_meter" do
    assert_difference('BillableMeter.count') do
      post billable_meters_url, params: { billable_meter: { end_time: @billable_meter.end_time, meter: @billable_meter.meter, percent_allocation: @billable_meter.percent_allocation, start_time: @billable_meter.start_time } }
    end

    assert_redirected_to billable_meter_url(BillableMeter.last)
  end

  test "should show billable_meter" do
    get billable_meter_url(@billable_meter)
    assert_response :success
  end

  test "should get edit" do
    get edit_billable_meter_url(@billable_meter)
    assert_response :success
  end

  test "should update billable_meter" do
    patch billable_meter_url(@billable_meter), params: { billable_meter: { end_time: @billable_meter.end_time, meter: @billable_meter.meter, percent_allocation: @billable_meter.percent_allocation, start_time: @billable_meter.start_time } }
    assert_redirected_to billable_meter_url(@billable_meter)
  end

  test "should destroy billable_meter" do
    assert_difference('BillableMeter.count', -1) do
      delete billable_meter_url(@billable_meter)
    end

    assert_redirected_to billable_meters_url
  end
end
