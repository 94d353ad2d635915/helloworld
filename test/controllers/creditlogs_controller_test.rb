require 'test_helper'

class CreditlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @creditlog = creditlogs(:one)
  end

  test "should get index" do
    get creditlogs_url
    assert_response :success
  end

  test "should get new" do
    get new_creditlog_url
    assert_response :success
  end

  test "should create creditlog" do
    assert_difference('Creditlog.count') do
      post creditlogs_url, params: { creditlog: { amount: @creditlog.amount, balance: @creditlog.balance, currency: @creditlog.currency, event_id: @creditlog.event_id } }
    end

    assert_redirected_to creditlog_url(Creditlog.last)
  end

  test "should show creditlog" do
    get creditlog_url(@creditlog)
    assert_response :success
  end

  test "should get edit" do
    get edit_creditlog_url(@creditlog)
    assert_response :success
  end

  test "should update creditlog" do
    patch creditlog_url(@creditlog), params: { creditlog: { amount: @creditlog.amount, balance: @creditlog.balance, currency: @creditlog.currency, event_id: @creditlog.event_id } }
    assert_redirected_to creditlog_url(@creditlog)
  end

  test "should destroy creditlog" do
    assert_difference('Creditlog.count', -1) do
      delete creditlog_url(@creditlog)
    end

    assert_redirected_to creditlogs_url
  end
end
