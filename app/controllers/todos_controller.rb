class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project
  before_action :find_todo, :only => [:show, :assign, :due, :trash, :untrash, :complete, :uncomplete]
  before_action :check_edit_permission, :only => [:edit, :update, :trash, :untrash]

  def new
    @todo = Todo.new
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to project_todo_path(@todo)
    else
      render :edit
    end
  end

  # def destroy
  #   @todo.destroy
  #   redirect_to project_path(@project)
  # end

  def show
    @messages = @todo.messages
  end

  def create
    @todo = Todo.new(todo_params)
    @team = @project.team
    @todo.project = @project
    @todo.user = current_user
    @todo.team = @team

    if @todo.save
      redirect_to project_path(@project)
    else
      render :new
    end

  end

  def assign
    @todo.update(todo_params)
    redirect_to project_path(@project)
  end

  def due
    @todo.update(todo_params)
    redirect_to project_path(@project)
  end

  def untrash
    @todo.untrash!
    redirect_to project_path(@project)
  end

  def trash
    @todo.trash!
    redirect_to project_path(@project)
  end

  def complete
    @todo.complete!
    redirect_to project_path(@project)
  end

  def uncomplete
    @todo.uncomplete!
    redirect_to project_path(@project)
  end

  private

  def find_project
    @project = current_user.participated_projects.find(params[:project_id])
  end

  def check_edit_permission
    if current_user == @project.user
      @todo = Todo.find(params[:id])
    elsif current_user.todos.find_by(id: params[:id])
      @todo = current_user.todos.find(params[:id])
    else
      redirect_to project_path(@project), alert: "You can trash others' todos!"
    end
  end

  def find_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :assign, :due)
  end

end
