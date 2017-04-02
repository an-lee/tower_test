class ProjectsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create]
  before_action :find_project_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: "Update Success!"
    else
      render :edit
    end
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to projects_path, notice: "New Project Created!"
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, alert: "Project Deleted!"
  end

  private

  def find_project_and_check_permission
    @project = Project.find(params[:id])
    if current_user != @project.user
      redirect_to root_path, alert: "You have no Permission"
    end
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end

end
