class EventsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]

  def index
    @team = current_user.participated_teams.find(params[:team_id])
    @events = @team.events.recent.paginate(:page => params[:page], :per_page => 50)
  end

  private

  def event_params
    params.require(:event).permit(:action, :content)
  end
end
