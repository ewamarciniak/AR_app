module TeamMembersHelper

  def is_a_lead?(teammember)
    teammember.lead ? "yes" : "no"
  end

  def team_members_projects?(tm)
    tm.projects.any?
  end

end