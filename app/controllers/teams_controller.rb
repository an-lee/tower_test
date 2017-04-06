class TeamsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :new, :show, :edit, :update, :destroy, :join, :quit]
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
    if @team.save
      @team.user.join_team!(@team)
      redirect_to teams_path, notice: "New team Created!"
    else
      render :new
    end
  end

  def edit
    @team = current_user.teams.find(params[:id])
  end

  def update
    @team = current_user.teams.find(params[:id])
    @team.update(team_params)
    if @team.save
      redirect_to team_path(@team), notice: "team Updated!"
    else
      render :edit
    end
  end

  def destroy
    @team = current_user.teams.find(params[:id])
    @team.destroy
    redirect_to teams_path, alert: "Team deleted!"
  end

  def join
    @team = Team.find(params[:id])
    if !current_user.is_member_of_team?(@team)
      current_user.join_team!(@team)
    end
      redirect_to team_path(@team)
  end

  def quit
    @team = current_user.participated_teams.find(params[:id])
    if current_user == @team.user
      flash[:alert] = "You are the creator!"
    else
      current_user.quit_team!(@team)
    end
    redirect_to team_path(@team)
  end

  private

  def team_params
    params.require(:team).permit(:title, :description)
  end

end
