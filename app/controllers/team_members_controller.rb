class TeamMembersController < ApplicationController
  # GET /team_members
  # GET /team_members.json
  def index
    @team_members = TeamMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @team_members }
    end
  end

  # GET /team_members/1
  # GET /team_members/1.json
  def show
    @team_member = TeamMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team_member }
    end
  end

  # GET /team_members/new
  # GET /team_members/new.json
  def new
    @team_member = TeamMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team_member }
    end
  end

  # GET /team_members/1/edit
  def edit
    @team_member = TeamMember.find(params[:id])
  end

  # POST /team_members
  # POST /team_members.json
  def create
    @team_member = TeamMember.new(params[:team_member])

    respond_to do |format|
      if @team_member.save
        format.html { redirect_to @team_member, notice: 'Team member was successfully created.' }
        format.json { render json: @team_member, status: :created, location: @team_member }
      else
        format.html { render action: "new" }
        format.json { render json: @team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /team_members/1
  # PUT /team_members/1.json
  def update
    @team_member = TeamMember.find(params[:id])

    respond_to do |format|
      if @team_member.update_attributes(params[:team_member])
        format.html { redirect_to @team_member, notice: 'Team member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_members/1
  # DELETE /team_members/1.json
  def destroy
    @team_member = TeamMember.find(params[:id])
    @team_member.destroy

    respond_to do |format|
      format.html { redirect_to team_members_url }
      format.json { head :no_content }
    end
  end
end
