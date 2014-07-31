class ProjectTeamMembersController < ApplicationController
  # GET /project_team_members
  # GET /project_team_members.json
  def index
    @project_team_members = ProjectTeamMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project_team_members }
    end
  end

  # GET /project_team_members/1
  # GET /project_team_members/1.json
  def show
    @project_team_member = ProjectTeamMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project_team_member }
    end
  end

  # GET /project_team_members/new
  # GET /project_team_members/new.json
  def new
    @project_team_member = ProjectTeamMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project_team_member }
    end
  end

  # GET /project_team_members/1/edit
  def edit
    @project_team_member = ProjectTeamMember.find(params[:id])
  end

  # POST /project_team_members
  # POST /project_team_members.json
  def create
    @project_team_member = ProjectTeamMember.new(params[:project_team_member])

    respond_to do |format|
      if @project_team_member.save
        format.html { redirect_to @project_team_member, notice: 'Project team member was successfully created.' }
        format.json { render json: @project_team_member, status: :created, location: @project_team_member }
      else
        format.html { render action: "new" }
        format.json { render json: @project_team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /project_team_members/1
  # PUT /project_team_members/1.json
  def update
    @project_team_member = ProjectTeamMember.find(params[:id])

    respond_to do |format|
      if @project_team_member.update_attributes(params[:project_team_member])
        format.html { redirect_to @project_team_member, notice: 'Project team member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project_team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_team_members/1
  # DELETE /project_team_members/1.json
  def destroy
    @project_team_member = ProjectTeamMember.find(params[:id])
    @project_team_member.destroy

    respond_to do |format|
      format.html { redirect_to project_team_members_url }
      format.json { head :no_content }
    end
  end
end
