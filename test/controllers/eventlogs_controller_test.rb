require 'test_helper'

class EventlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eventlog = eventlogs(:one)
  end

  test "should get index" do
    get eventlogs_url
    assert_response :success
  end

  test "should get new" do
    get new_eventlog_url
    assert_response :success
  end

  test "should create eventlog" do
    assert_difference('Eventlog.count') do
      post eventlogs_url, params: { eventlog: { create_at: @eventlog.create_at, description: @eventlog.description, event_id: @eventlog.event_id, user_agent: @eventlog.user_agent, user_id: @eventlog.user_id } }
    end

    assert_redirected_to eventlog_url(Eventlog.last)
  end

  test "should show eventlog" do
    get eventlog_url(@eventlog)
    assert_response :success
  end

  test "should get edit" do
    get edit_eventlog_url(@eventlog)
    assert_response :success
  end

  test "should update eventlog" do
    patch eventlog_url(@eventlog), params: { eventlog: { create_at: @eventlog.create_at, description: @eventlog.description, event_id: @eventlog.event_id, user_agent: @eventlog.user_agent, user_id: @eventlog.user_id } }
    assert_redirected_to eventlog_url(@eventlog)
  end

  test "should destroy eventlog" do
    assert_difference('Eventlog.count', -1) do
      delete eventlog_url(@eventlog)
    end

    assert_redirected_to eventlogs_url
  end
end
