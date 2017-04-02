class EventsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_action :find_team, :only => [:index, :new, :create, :destroy]

  def index
    @projects = @team.projects
  end

  def new

  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    @event.team = @team
  end

  private

  def find_team
    @team = Team.find(params[:team_id])
  end

  def event_params
    params.require(:event).permit(:action, :title, :content)
  end
end
