class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project_and_todo

  def create
    
    @message = Message.new(message_params)
    @message.todo = @todo
    @message.user = current_user

    if @message.save
      Event.build1(current_user, "回复了任务", @todo, @project, @message, 1)
      redirect_to project_todo_path(@project, @todo)
    end
  end

  def new
    @message = Message.new
  end

  private

  def find_project_and_todo
    @project = Project.find(params[:project_id])
    @todo = Todo.find(params[:todo_id])
  end

  def message_params
    params.require(:message).permit(:title, :content)
  end

end
