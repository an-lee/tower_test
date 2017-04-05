class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_action :find_project
  before_action :find_user_todo_team, :only => [:show, :assign, :due, :trash, :untrash, :complete, :uncomplete]

  def new
    @todo = Todo.new
  end

  def show
    @messages = @todo.messages
  end

  def create

    @todo = Todo.new(todo_params)
    @user = current_user
    @team = @project.team

    @todo.project = @project
    @todo.user = @user
    @todo.team = @team

    if @todo.save!
      redirect_to project_path(@project)
    else
      render :new
    end

  end

  def assign
    @todo.update(todo_params)
    redirect_to :back
  end

  def due
    @todo.update(todo_params)
    # byebug
    redirect_to :back
  end

  def untrash
    @todo.untrash!
    redirect_to :back
  end

  def trash
    @todo.trash!
    redirect_to :back
  end

  def complete
    @todo.complete!
    redirect_to :back
  end

  def uncomplete
    @todo.uncomplete!
    redirect_to :back
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_user_todo_team
    @todo = Todo.find(params[:id])
    @user = current_user
    @team = @todo.team
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :assign, :due)
  end

end
