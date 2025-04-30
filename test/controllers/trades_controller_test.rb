require "test_helper"

class TradesControllerTest < ActionDispatch::IntegrationTest
  test "should get new_buy" do
    get trades_new_buy_url
    assert_response :success
  end

  test "should get create_buy" do
    get trades_create_buy_url
    assert_response :success
  end

  test "should get new_sell" do
    get trades_new_sell_url
    assert_response :success
  end

  test "should get create_sell" do
    get trades_create_sell_url
    assert_response :success
  end
end
