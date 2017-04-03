class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :member_of_team_required , only: [:show]

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    @projects = @team.projects
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    current_user.join_team!(@team)
    if @team.save
      redirect_to teams_path, notice: "New team Created!"
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_path, alert: "Team deleted!"
  end

  def join
    @team = Team.find(params[:id])
    if !current_user.is_member_of_team?(@team)
      current_user.join_team!(@team)
    else
      redirect_to :back
    end
  end

  def quit
    @team = Team.find(params[:id])
    if current_user == @team.user
      redirect_to :back, alert: "You are the creator!"
    elsif
      current_user.is_member_of_team?(@team)
      current_user.quit_team!(@team)
    else
      redirect_to :back
    end
  end

  private

  def team_params
    params.require(:team).permit(:title, :description)
  end

end
