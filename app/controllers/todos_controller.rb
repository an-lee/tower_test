class TodosController < ApplicationController
  before_filter :authenticate_user!
  before_action :find_project
  before_action :find_todo, :only => [:show, :assign, :due, :trash, :untrash, :complete, :uncomplete]

  def new
    @todo = Todo.new
  end

  def show
    @messages = @todo.messages
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.project = @project
    @todo.user = current_user

    if @todo.save
      Event.build(current_user, "创建了任务", @todo, @project)
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def assign
    old_assign = @todo.assign
    @todo.update(todo_params)
    if old_assign == nil
      Event.build(current_user, "给 #{@todo.assign} 指派了任务", @todo, @project)
    elsif old_assign == @todo.assign
      flash[:alert] = "你把任务指派给了相同的人"
    else
      Event.build(current_user, "把 #{old_assign} 的任务指派给了 #{@todo.assign}", @todo, @project)
    end
    redirect_to :back
  end

  def due
    old_due = @todo.due
    @todo.update(todo_params)
    if old_due == nil
      Event.build(current_user, "为任务设置了截止时间为 #{@todo.due}", @todo, @project)
    elsif old_due == @todo.due
      flash[:alert] = "你为任务设置的相同的截止时间"
    else
      Event.build(current_user, "把任务的截止时间由 #{old_due} 改成了 #{@todo.due}", @todo, @project)
    end
    redirect_to :back
  end

  def untrash
    @todo.untrash!
    @todo.save
    Event.build(current_user, "恢复了任务", @todo, @project)
    redirect_to :back
  end

  def trash
    @todo.trash!
    @todo.save
    Event.build(current_user, "删除了任务", @todo, @project)
    redirect_to :back
  end

  def complete
    @todo.complete!
    @todo.save
    Event.build(current_user, "完成了任务", @todo, @project)
    redirect_to :back
  end

  def uncomplete
    @todo.uncomplete!
    @todo.save
    Event.build(current_user, "重新打开了任务", @todo, @project)
    redirect_to :back
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due, :assign, :user_id)
  end

end
