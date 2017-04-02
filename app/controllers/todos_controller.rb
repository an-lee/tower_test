class TodosController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_action :find_project, :only => [:new, :show, :create, :edit, :update, :destroy, :untrash, :trash, :complete, :uncomplete, :assign, :due]

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.project = @project
    @todo.user = current_user

    if @todo.save
      render_create_event("创建了任务", @todo, @project)
      redirect_to project_path(@project)
    else
      render :new
    end
  end

  def assign
    @todo = Todo.find(params[:id])
    old_assign = User.find_by_id(@todo.assign)
    @todo.update(todo_params)
    new_assign = User.find_by_id(@todo.assign)
    if old_assign != nil
      render_create_event("把#{old_assign.email}的任务指派给了#{new_assign.email}", @todo, @project)
    else
      render_create_event("给#{@todo.assign}指派了任务", @todo, @project)
    end
    redirect_to :back
  end

  def due
    @todo = Todo.find(params[:id])
    old_due = @todo.due
    @todo.update(todo_params)
    new_due = @todo.due
    if old_due != nil
      render_create_event("把任务的时间由#{old_due}改成了#{new_due}", @todo, @project)
    else
      render_create_event("为任务设置了截止时间#{new_due}", @todo, @project)
    end
    redirect_to :back
  end

  def untrash
    @todo = Todo.find(params[:id])
    @todo.untrash!
    @todo.save
    render_create_event("恢复了任务", @todo, @project)
    redirect_to :back
  end

  def trash
    @todo = Todo.find(params[:id])
    @todo.trash!
    @todo.save
    render_create_event("删除了任务", @todo, @project)
    redirect_to :back
  end

  def complete
    @todo = Todo.find(params[:id])
    @todo.complete!
    @todo.save
    render_create_event("完成了任务", @todo, @project)
    redirect_to :back
  end

  def uncomplete
    @todo = Todo.find(params[:id])
    @todo.uncomplete!
    @todo.save
    render_create_event("撤销了任务完成状态", @todo, @project)
    redirect_to :back
  end

  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :due, :assign, :user_id)
  end

  def render_create_event(action, todo, project)
    @event = Event.new(:action => action,
                       :content => todo.description,
                       :title => todo.title)
    @event.user = current_user
    @event.project = project
    @event.team = project.team
    @event.todo = todo
    @event.save!
  end

end
