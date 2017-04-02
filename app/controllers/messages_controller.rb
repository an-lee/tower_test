class MessagesController < ApplicationController

  def create
    @project = Project.find(params[:project_id])
    @todo = Todo.find(params[:todo_id])
    @message = Message.new(message_params)
    @message.todo = @todo
    @message.user = current_user
    if @message.save
      render_create_event("回复了任务", @todo, @project)
      redirect_to project_todo_path(@project, @todo)
    end
  end

  def new
    @project = Project.find(params[:project_id])
    @todo = Todo.find(params[:todo_id])
    @message = Message.new
  end

  private

  def message_params
    params.require(:message).permit(:title, :content)
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
