require "test_helper"

class Api::StocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_stocks_index_url
    assert_response :success
  end
end
