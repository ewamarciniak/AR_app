require 'test_helper'

class ProjectTeamMembersControllerTest < ActionController::TestCase
  setup do
    @project_team_member = project_team_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_team_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_team_member" do
    assert_difference('ProjectTeamMember.count') do
      post :create, project_team_member: {  }
    end

    assert_redirected_to project_team_member_path(assigns(:project_team_member))
  end

  test "should show project_team_member" do
    get :show, id: @project_team_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_team_member
    assert_response :success
  end

  test "should update project_team_member" do
    put :update, id: @project_team_member, project_team_member: {  }
    assert_redirected_to project_team_member_path(assigns(:project_team_member))
  end

  test "should destroy project_team_member" do
    assert_difference('ProjectTeamMember.count', -1) do
      delete :destroy, id: @project_team_member
    end

    assert_redirected_to project_team_members_path
  end
end
