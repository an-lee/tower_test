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
      Event.build_todo(current_user, "创建了任务", @todo, @todo.project, @todo.team)
      redirect_to project_path(@project)
    else
      render :new
    end

  end

  def assign
    old_assgin = @todo.assign
    @todo.update(todo_params)
    new_assgin = @todo.assign
    if old_assgin != new_assgin && old_assgin == nil
      Event.build_todo(current_user, "给 #{new_assgin} 指派了任务", @todo, @todo.project, @todo.team)
    elsif old_assgin != new_assgin && old_assgin != nil
      Event.build_todo(current_user, "把 #{old_assgin} 的任务指派给了 #{new_assgin}", @todo, @todo.project, @todo.team)
    end
    redirect_to project_path(@project)
  end

  def due
    old_due = @todo.due
    @todo.update(todo_params)
    new_due = @todo.due
    if new_due != old_due && old_due == nil
      Event.build_todo(current_user, "将任务完成时间从 没有截止日期 修改为 #{new_due}", @todo, @todo.project, @todo.team)
    elsif new_due != old_due && old_due != nil
      Event.build_todo(current_user, "将任务完成时间从 #{old_due} 修改为 #{new_due}", @todo, @todo.project, @todo.team)
    end
    redirect_to project_path(@project)
  end

  def untrash
    @todo.untrash!
    Event.build_todo(current_user, "恢复了任务", @todo, @todo.project, @todo.team)
    redirect_to project_path(@project)
  end

  def trash
    @todo.trash!
    Event.build_todo(current_user, "删除了任务", @todo, @todo.project, @todo.team)
    redirect_to project_path(@project)
  end

  def complete
    @todo.complete!
    Event.build_todo(current_user, "完成了任务", @todo, @todo.project, @todo.team)
    redirect_to project_path(@project)
  end

  def uncomplete
    @todo.uncomplete!
    Event.build_todo(current_user, "重新打开了任务", @todo, @todo.project, @todo.team)
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
