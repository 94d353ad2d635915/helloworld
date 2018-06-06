require 'test_helper'

class Console::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get console_home_index_url
    assert_response :success
  end

end
