class EventsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    @team = Team.find(params[:team_id])
    if !current_user.is_member_of_team?(@team)
      redirect_to root_path, alert: "You are not member of the team!"
    else
      @events = @team.events.recent.paginate(:page => params[:page], :per_page => 50)
    end
  end

  def new
  end

  def create
  end

  private

  def event_params
    params.require(:event).permit(:action, :title, :content)
  end
end
