class TeamsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create]

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

  private

  def team_params
    params.require(:team).permit(:title, :description)
  end

end
