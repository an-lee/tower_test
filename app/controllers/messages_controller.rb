class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project_and_todo

  def create

    @message = Message.new(message_params)
    @message.todo = @todo
    @message.project = @project
    @message.user = current_user

    if @message.save
      if @todo != nil
        redirect_to project_todo_path(@project, @todo)
      else
        redirect_to project_path(@project)
      end
    else
      render :new
    end

  end

  def new
    @message = Message.new
  end

  private

  def find_project_and_todo
    @project = Project.find(params[:project_id])
    if Todo.find_by_id(params[:todo_id])
      @todo = Todo.find(params[:todo_id])
    end
  end

  def message_params
    params.require(:message).permit(:title, :content)
  end

end
