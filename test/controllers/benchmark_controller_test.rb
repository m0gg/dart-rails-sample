require 'test_helper'

class BenchmarkControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
