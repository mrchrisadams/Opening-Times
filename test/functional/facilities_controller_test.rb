require 'test_helper'

class FacilitiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:facilities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create facility" do
    assert_difference('Facility.count') do
      post :create, :facility => { }
    end

    assert_redirected_to facility_path(assigns(:facility))
  end

  test "should show facility" do
    get :show, :id => facilities(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => facilities(:one).to_param
    assert_response :success
  end

  test "should update facility" do
    put :update, :id => facilities(:one).to_param, :facility => { }
    assert_redirected_to facility_path(assigns(:facility))
  end

  test "should destroy facility" do
    assert_difference('Facility.count', -1) do
      delete :destroy, :id => facilities(:one).to_param
    end

    assert_redirected_to facilities_path
  end
end
