require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  describe "GET index: " do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when login as team member" do

      it "render index template" do
        sign_in member
        team = create(:team)
        member.join_team!(team)
        event1 = create(:event, team: team)
        event2 = create(:event, team: team)
        get :index, params: {team_id: team.id}
        expect(response).to render_template("index")
      end

      context "when login as project member" do
        before {sign_in member}
        it "assigns @events" do
          team = create(:team)
          project = create(:project, team: team)
          member.join_team!(team)
          member.join_project!(project)
          event1 = create(:event, team: team, project: project)
          event2 = create(:event, team: team, project: project)
          get :index, params: {team_id: team.id}
          expect(assigns[:events]).to eq([event2, event1])
        end

      end

      context "when login as not project member" do
        before {sign_in member}

        it "doesn't assigns @events" do
          team = create(:team)
          project = create(:project, team: team)
          member.join_team!(team)
          event1 = create(:event, team: team, project: project)
          event2 = create(:event, team: team, project: project)
          get :index, params: {team_id: team.id}
          expect(assigns[:events]).to eq([])
        end
      end

    end

    context "when login as not team member" do
      before {sign_in not_member}
      it "raise errors" do
        team = create(:team)
        event1 = create(:event, team: team)
        event2 = create(:event, team: team)
        expect do
          get :index, params: {team_id: team.id}
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

  end

end
