class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def member_of_team_required
    @user = current_user
    @team = Team.find(params[:id])
    if !@user.is_member_of_team?(@team)
      redirect_to root_path, alert: "You are not member of the team!"
    end
  end

  def member_of_project_required
    @user = current_user
    @project = Project.find(params[:id])
    if !@user.is_member_of_project?(@project)
      redirect_to root_path, alert: "You are not member of the project!"
    end
  end

end
