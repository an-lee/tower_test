class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project_and_check_permission, only: [:edit, :update, :destroy]
  before_action :find_team, only: [:new, :create, :join, :quit]
  before_action :member_of_project_required, only: [:show, :quit]

  def new
    @project = Project.new
  end

  def show
    @team = current_user.participated_projects.find(params[:id])
    @todos = @project.todos
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Update Success!"
    else
      render :edit
    end
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @project.team = @team
    if @project.save
      current_user.join_project!(@project)
      redirect_to team_projects_path(@team), notice: "New Project Created!"
    else
      render :new
    end
  end

  def destroy
    @team = @project.team
    @project.destroy
    redirect_to team_projects_path(@team), alert: "Project Deleted!"
  end

  def join
    @project = Project.find(params[:id])
    if !current_user.is_member_of_project?(@project)
      current_user.join_project!(@project)
    end
    redirect_to project_path(@project)
  end

  def quit
    @project = Project.find(params[:id])
    if current_user == @project.user
      flash[:alert] = "You are the creator!"
    else
      current_user.quit_project!(@project)
    end
    redirect_to team_projects_path(@team)
  end

  private

  def find_team
    @team = current_user.participated_teams.find(params[:team_id])
  end

  def find_project_and_check_permission
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end

end
