class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @team = current_user.participated_teams.find(params[:team_id])
    @projects = @team.projects
    @projects_joined = current_user.participated_projects
    @projects = @projects & @projects_joined
    @events = @projects.collect{ |project| project.events }.flatten
    @events = @events.sort_by(&:id).reverse
    @events = @events.paginate(:page => params[:page], :per_page => 50)
  end

  private

  def event_params
    params.require(:event).permit(:action, :content)
  end
end
