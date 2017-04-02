class TodosController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_action :find_project, :only => [:new, :show, :create, :edit, :update, :destroy]

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.project = @project
    @todo.user = current_user

    if @todo.save
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def edit
    @todo = Todo.find(params[:id])
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.update(todo_params)
    redirect_to project_path(@project)
  end

  def destroy
    @todo = Todo.find(params[:id])
    if current_user = @todo.user
      @todo.destroy
      redirect_to project_path(@project)
    end
  end

  def assign
    @todo = Todo.find(params[:id])
    @todo.update(todo_params)
  end

  def due
    @todo = Todo.find(params[:id])
    @todo.update(todo_params)
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due, :assign, :user_id)
  end

end
