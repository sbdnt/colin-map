require 'test_helper'

class ClaimedsControllerTest < ActionController::TestCase
  setup do
    @claimed = claimeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:claimeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create claimed" do
    assert_difference('Claimed.count') do
      post :create, claimed: { address: @claimed.address, latitude: @claimed.latitude, longitude: @claimed.longitude, user_id: @claimed.user_id }
    end

    assert_redirected_to claimed_path(assigns(:claimed))
  end

  test "should show claimed" do
    get :show, id: @claimed
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @claimed
    assert_response :success
  end

  test "should update claimed" do
    patch :update, id: @claimed, claimed: { address: @claimed.address, latitude: @claimed.latitude, longitude: @claimed.longitude, user_id: @claimed.user_id }
    assert_redirected_to claimed_path(assigns(:claimed))
  end

  test "should destroy claimed" do
    assert_difference('Claimed.count', -1) do
      delete :destroy, id: @claimed
    end

    assert_redirected_to claimeds_path
  end
end
