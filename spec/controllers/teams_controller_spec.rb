require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  describe "GET index" do

    it "assigns @teams" do
      team1 = create(:team)
      team2 = create(:team)
      get :index
      expect(assigns[:teams]).to eq([team1, team2])
    end

    it "render template" do
      team1 = create(:team)
      team2 = create(:team)
      get :index
      expect(response).to render_template("index")
    end

  end

# =======================

  describe "GET new" do

    context "when user login" do

      let(:user) {create(:user)}
      let(:team) {create(:team)}

      before do
        sign_in user
        get :new
      end

      it "assigns @team" do
        expect(assigns(:team)).to be_a_new(Team)
      end

      it "render template" do
        expect(response).to render_template("new")
      end

    end

    context "when user not login" do

      it "redirect_to new_user_session_path" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end

    end
  end

# =======================

  describe "POST create" do
    let(:user) {create(:user)}
    before {sign_in user}

    context "when team dosen't have title" do

      it "doesn't create a record" do
        expect do
          post :create, params: {team: {:description => "bar"}}
        end.to change { Team.count }.by(0)
      end

      it "render new template" do
        post :create, params: { team: { :description => "bar" } }
        expect(response).to render_template("new")
      end

    end

    context "when team has title" do

      it "create a new team record" do
        team = build(:team)
        expect do
          post :create, params: { team: attributes_for(:team)}
        end.to change {Team.count}.by(1)
      end

      it "redirect_to teams_path" do
        team = build(:team)
        post :create, params: {team: attributes_for(:team)}
        expect(response).to redirect_to teams_path
      end

      it "creates a team for user and become member" do
        team = build(:team)
        post :create, params: {team: attributes_for(:team)}
        expect(Team.last.user).to eq(user)
        # byebug
        expect(user.is_member_of_team?(Team.last)).to eq(true)
      end

    end

  end

# =======================

  describe "GET show: " do

    let(:user) {create(:user)}
    let(:team) {create(:team)}

    before { sign_in user }

    context "when user is a member of team" do

      before do
        post :join, params: {id: team.id}
      end

      it "assigns @team" do
        get :show, params: {id: team.id}
        expect(assigns[:team]).to eq(team)
      end

      it "render template" do
        get :show, params: {id: team.id}
        expect(response).to render_template("show")
      end

    end

    context "when user is not a member of team" do

      it "redirect_to root_path" do
        get :show, params: {id: team.id}
        expect(response).to redirect_to root_path
      end

    end

  end

# =======================

  describe "PUT edit:" do

    let(:creator) {create(:user)}
    let(:not_creator) {create(:user)}

    context "signed in as creator" do
      before {sign_in creator}

      it "assigns team" do
        team = create(:team, user: creator)
        get :edit, params: {:id => team.id}
        expect(assigns[:team]).to eq(team)
      end

      it "renders template" do
        team = create(:team, user:creator)
        get :edit, params: {:id => team.id}
        expect(response).to render_template("edit")
      end

    end

    context "signed in not as creator" do
      before {sign_in not_creator}

      it "raise an error" do
        team = create(:team, user:creator)
        expect do
          get :edit, params: {:id => team.id}
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================

  describe "PUT update" do

    let(:creator) {create(:user)}
    let(:not_creator) {create(:user)}

    context "when sign in as creator" do
      before {sign_in creator}

      context "when team has title" do
        it "assigns @team" do
          team = create(:team, user:creator)
          put :update, params: {id: team.id, team:{title: "Title", description:"Description"}}
          expect(assigns[:team]).to eq(team)
        end

        it "changes value" do
          team = create(:team, user:creator)
          put :update, params: {id: team.id, team:{title: "Title", description:"Description"}}
          expect(assigns[:team].title).to eq("Title")
          expect(assigns[:team].description).to eq("Description")
        end

        it "redirect_to team_path" do
          team = create(:team, user:creator)
          put :update, params: {id: team.id, team:{title: "Title", description:"Description"}}
          expect(response).to redirect_to team_path(team)
        end
      end

      context "when team doesn't has title" do

        it "doesn't update a record" do
          team = create(:team, user:creator)
          put :update, params: {id: team.id, team:{title: "", description:"new Description"}}
          expect(team.description).not_to eq("new Description")
        end

        it "renders edit template" do
          team = create(:team, user:creator)
          put :update, params: {id: team.id, team:{title: "", description:"new Description"}}
          expect(response).to render_template("edit")
        end

      end

    end

    context "when sign in not as creator" do
      before {sign_in not_creator}

      it "raise an error" do
        team = create(:team, user:creator)
        expect do
          put :update, params: {id: team.id, team: { title: "Title", description: "Description"}}
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================

  describe "DELETE destroy: " do
    let(:creator) {create(:user)}
    let(:not_creator) {create(:user)}

    context "when sign in as creator" do
      before { sign_in creator }

      it "assigns @team" do
        team = create(:team, user: creator)
        delete :destroy, params: {id: team.id}
        expect(assigns[:team]).to eq(team)
      end

      it "delete a record" do
        team = create(:team, user: creator)
        expect{delete:destroy, params:{id: team.id}}.to change{Team.count}.by(-1)
      end

      it "redirect_to teams_path" do
        team = create(:team, user: creator)
        delete :destroy, params: {id: team.id}
        expect(response).to redirect_to teams_path
      end

    end

    context "when sign in not as creator" do
      before { sign_in not_creator }
      it "raise an error" do
        team = create(:team, user: creator)
        expect do
          delete :destroy, params: { id: team.id }
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================

  describe "POST join" do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when sign in as not member" do
      before {sign_in not_member}

      it "become member of team" do
        team = create(:team, user: member)
        post :join, params: {id: team.id}
        expect(not_member.is_member_of_team?(team)).to eq(true)
      end

      it "redirect_to team_path" do
        team = create(:team, user: member)
        post :join, params: {id: team.id}
        expect(response).to redirect_to team_path(team)
      end

    end

    context "when sign in as member" do
      before {sign_in member}

      it "still member of team" do
        team = create(:team, user: member)
        post :join, params: {id: team.id}
        expect(member.is_member_of_team?(team)).to eq(true)
      end

      it "redirect_to team_path" do
        team = create(:team, user: member)
        post :join, params: {id: team.id}
        expect(response).to redirect_to team_path(team)
      end

    end

  end

# =======================

  describe "POST quit" do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when sign in as member" do
      before {sign_in member}

      it "become no member of team" do
        team = create(:team, user: member)
        post :quit, params: {id: team.id}
        expect(member.is_member_of_team?(team)).to eq(false)
      end

      it "redirect_to team_path" do
        team = create(:team, user: member)
        post :quit, params: {id: team.id}
        expect(response).to redirect_to team_path(team)
      end

    end

    context "when sign in not as member" do
      before {sign_in not_member}

      it "still no member of team" do
        team = create(:team, user: member)
        post :quit, params: {id: team.id}
        expect(not_member.is_member_of_team?(team)).to eq(false)
      end

      it "redirect_to team_path" do
        team = create(:team, user: member)
        post :quit, params: {id: team.id}
        expect(response).to redirect_to team_path(team)
      end

    end

  end

end
