require 'test_helper'

class LegalContractsControllerTest < ActionController::TestCase
  setup do
    @legal_contract = legal_contracts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:legal_contracts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create legal_contract" do
    assert_difference('LegalContract.count') do
      post :create, legal_contract: { copy_stored: @legal_contract.copy_stored, revised_on: @legal_contract.revised_on, signed_on: @legal_contract.signed_on }
    end

    assert_redirected_to legal_contract_path(assigns(:legal_contract))
  end

  test "should show legal_contract" do
    get :show, id: @legal_contract
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @legal_contract
    assert_response :success
  end

  test "should update legal_contract" do
    put :update, id: @legal_contract, legal_contract: { copy_stored: @legal_contract.copy_stored, revised_on: @legal_contract.revised_on, signed_on: @legal_contract.signed_on }
    assert_redirected_to legal_contract_path(assigns(:legal_contract))
  end

  test "should destroy legal_contract" do
    assert_difference('LegalContract.count', -1) do
      delete :destroy, id: @legal_contract
    end

    assert_redirected_to legal_contracts_path
  end
end
