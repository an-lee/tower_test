module TeamsHelper
  def render_team_description(team)
    simple_format(team.description)
  end
end
