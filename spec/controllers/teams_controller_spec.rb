require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  describe "GET index" do

    context "when user login" do

      before do
        user = create(:user)
        sign_in user
      end

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

    context "when user not login" do

      it "redirect_to root_path" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end

    end

  end

# =======================

  describe "GET new" do

    context "when user login" do

      before do
        user = create(:user)
        sign_in user
      end

      it "assigns @team" do
        team = build(:team)
        get :new
        expect(assigns(:team)).to be_a_new(Team)
      end

      it "render template" do
        team1 = build(:team)
        get :new
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

  describe "GET show: " do

    context "when user is a member of team" do

      it ", assigns @team" do
        user = create(:user)
        sign_in user
        team = create(:team)
        # byebug
        # put :join, params: {id: team.id}
        get :show, params: {id: team.id}
        expect(assigns[:team]).to eq(team)
      end

      it ", render template" do
        user = create(:user)
        sign_in user
        team = create(:team)
        byebug
        # post :join, params: {id: team.id}
        get :show, params: {id: team.id}
        expect(response).to render_template("show")
      end

    end

    # context "when user is not a member of team" do
    #   team = create(:team)
    #   user.quit!(team)
    #   get :show, params: {id: team.id}
    #   expect(response).to redirect_to root_path
    # end

  end

end
