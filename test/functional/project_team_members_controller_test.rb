require 'test_helper'

class ProjectsTeamMembersControllerTest < ActionController::TestCase
  setup do
    @projects_team_member = projects_team_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects_team_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create projects_team_member" do
    assert_difference('ProjectsTeamMember.count') do
      post :create, projects_team_member: {  }
    end

    assert_redirected_to projects_team_member_path(assigns(:projects_team_member))
  end

  test "should show projects_team_member" do
    get :show, id: @projects_team_member
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @projects_team_member
    assert_response :success
  end

  test "should update projects_team_member" do
    put :update, id: @projects_team_member, projects_team_member: {  }
    assert_redirected_to projects_team_member_path(assigns(:projects_team_member))
  end

  test "should destroy projects_team_member" do
    assert_difference('ProjectsTeamMember.count', -1) do
      delete :destroy, id: @projects_team_member
    end

    assert_redirected_to projects_team_members_path
  end
end
