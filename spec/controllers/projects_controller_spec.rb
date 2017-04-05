require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

# =======================

  describe "GET new" do

    let(:user) {create(:user)}

    context "when user login" do
      before{ sign_in user }

      context "when user is member of team" do

        it "assigns @project" do
          team = create(:team, user: user)
          user.join_team!(team)
          # byebug
          get :new, params: {team_id: team.id}
          expect(assigns(:project)).to be_a_new(Project)
        end

        it "render template" do
          team = create(:team, user: user)
          user.join_team!(team)
          get :new, params: {team_id: team.id}
          expect(response).to render_template("new")
        end

      end

      context "when user is not member of team" do
        it "raise errors" do
          team = create(:team, user: user)
          # byebug
          expect do
            get :new, params: {team_id: team.id}
          end.to raise_error ActiveRecord::RecordNotFound
        end
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

  # describe "POST create" do
  #
  #   let(:user) {create(:user)}
  #
  #   context "when project dosen't have title" do
  #     before {sign_in user}
  #
  #     it "doesn't create a record" do
  #       team = create(:team, user: user)
  #       user.join_team!(team)
  #       # byebug
  #       expect do
  #         post :create, params: {project: { :team_id => team.id, :user_id => user.id, description: "bar"}}
  #       end.to change { Project.count }.by(0)
  #     end
  #
  #     it "render new template" do
  #       team = create(:team, user: user)
  #       user.join_team!(team)
  #       post :create, params: { project: { :team_id => team.id, :user_id => user.id, :description => "bar" } }
  #       expect(response).to render_template("new")
  #     end
  #
  #   end
  #
  #   context "when project has title" do
  #     before do
  #       sign_in user
  #     end
  #     it "create a new project record" do
  #       team = create(:team, user: user)
  #       user.join_team!(team)
  #       project = build(:project)
  #       expect do
  #         post :create, params: { project: attributes_for(:project)}
  #       end.to change {Project.count}.by(1)
  #     end
  #
  #     it "redirect_to projects_path" do
  #       team = create(:team, user: user)
  #       user.join_team!(team)
  #       project = build(:project)
  #       post :create, params: {project: attributes_for(:project)}
  #       expect(response).to redirect_to projects_path
  #     end
  #
  #     it "creates a project for user and become member" do
  #       team = create(:team, user: user)
  #       user.join_team!(team)
  #       project = build(:project)
  #       post :create, params: {project: attributes_for(:project)}
  #       expect(Project.last.user).to eq(user)
  #       # byebug
  #       expect(user.is_member_of_project?(Project.last)).to eq(true)
  #     end
  #
  #   end
  #
  # end

# =======================

  describe "GET show: " do

    let(:user) {create(:user)}
    before { sign_in user }

    context "when user is a member of team" do

      context "when user is a member of project" do
        before do
          @team = create(:team, user: user)
          user.join_team!(@team)
          @project = create(:project, user: user, team: @team)
          post :join, params: {id: @project.id, team_id: @team.id}
        end

        it "assigns @project" do
          get :show, params: {id: @project.id}
          expect(assigns[:project]).to eq(@project)
        end

        it "render template" do
          get :show, params: {id: @project.id}
          expect(response).to render_template("show")
        end

      end

      context "when user is not a member of project" do

        it "redirect_to root_path" do
          team = create(:team, user: user)
          user.join_team!(team)
          project = create(:project, user: user, team: team)
          get :show, params: {id: project.id}
          expect(response).to redirect_to root_path
        end

      end
    end

    context "when user is not a member of team" do
      let(:project) {create(:project)}
      it "redirect_to root_path" do
        get :show, params: {id: project.id}
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

      it "assigns project" do
        project = create(:project, user: creator)
        get :edit, params: {:id => project.id}
        expect(assigns[:project]).to eq(project)
      end

      it "renders template" do
        project = create(:project, user:creator)
        get :edit, params: {:id => project.id}
        expect(response).to render_template("edit")
      end

    end

    context "signed in not as creator" do
      before {sign_in not_creator}

      it "raise an error" do
        project = create(:project, user:creator)
        expect do
          get :edit, params: {:id => project.id}
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

      context "when project has title" do
        it "assigns @project" do
          project = create(:project, user:creator)
          put :update, params: {id: project.id, project:{title: "Title", description:"Description"}}
          expect(assigns[:project]).to eq(project)
        end

        it "changes value" do
          project = create(:project, user:creator)
          put :update, params: {id: project.id, project:{title: "Title", description:"Description"}}
          expect(assigns[:project].title).to eq("Title")
          expect(assigns[:project].description).to eq("Description")
        end

        it "redirect_to project_path" do
          project = create(:project, user:creator)
          put :update, params: {id: project.id, project:{title: "Title", description:"Description"}}
          expect(response).to redirect_to project_path(project)
        end
      end

      context "when project doesn't has title" do

        it "doesn't update a record" do
          project = create(:project, user:creator)
          put :update, params: {id: project.id, project:{title: "", description:"new Description"}}
          expect(project.description).not_to eq("new Description")
        end

        it "renders edit template" do
          project = create(:project, user:creator)
          put :update, params: {id: project.id, project:{title: "", description:"new Description"}}
          expect(response).to render_template("edit")
        end

      end

    end

    context "when sign in not as creator" do
      before {sign_in not_creator}

      it "raise an error" do
        project = create(:project, user:creator)
        expect do
          put :update, params: {id: project.id, project: { title: "Title", description: "Description"}}
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

      it "assigns @project" do
        project = create(:project, user: creator)
        delete :destroy, params: {id: project.id}
        expect(assigns[:project]).to eq(project)
      end

      it "delete a record" do
        project = create(:project, user: creator)
        expect{delete:destroy, params:{id: project.id}}.to change{Project.count}.by(-1)
      end

      it "redirect_to projects_path" do
        project = create(:project, user: creator)
        delete :destroy, params: {id: project.id}
        expect(response).to redirect_to team_projects_path(project.team)
      end

    end

    context "when sign in not as creator" do
      before { sign_in not_creator }
      it "raise an error" do
        project = create(:project, user: creator)
        expect do
          delete :destroy, params: { id: project.id }
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

      it "become member of project" do
        project = create(:project, user: member)
        not_member.join_team!(project.team)
        post :join, params: {id: project.id, team_id: project.team_id}
        expect(not_member.is_member_of_project?(project)).to eq(true)
      end

      it "redirect_to project_path" do
        project = create(:project, user: member)
        not_member.join_team!(project.team)
        post :join, params: {id: project.id, team_id: project.team_id}
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in as member" do
      before {sign_in member}

      it "still member of project" do
        project = create(:project, user: member)
        member.join_team!(project.team)
        post :join, params: {id: project.id, team_id: project.team_id}
        expect(member.is_member_of_project?(project)).to eq(true)
      end

      it "redirect_to project_path" do
        project = create(:project, user: member)
        member.join_team!(project.team)
        post :join, params: {id: project.id, team_id: project.team_id}
        expect(response).to redirect_to project_path(project)
      end

    end

  end

# =======================

  # describe "POST quit" do
  #   let(:member) {create(:user)}
  #   let(:not_member) {create(:user)}
  #
  #   context "when sign in as member" do
  #     before {sign_in member}
  #
  #     it "become no member of project" do
  #       project = create(:project, user: member)
  #       post :quit, params: {id: project.id}
  #       expect(member.is_member_of_project?(project)).to eq(false)
  #     end
  #
  #     it "redirect_to project_path" do
  #       project = create(:project, user: member)
  #       post :quit, params: {id: project.id}
  #       expect(response).to redirect_to project_path(project)
  #     end
  #
  #   end
  #
  #   context "when sign in not as member" do
  #     before {sign_in not_member}
  #
  #     it "still no member of project" do
  #       project = create(:project, user: member)
  #       post :quit, params: {id: project.id}
  #       expect(not_member.is_member_of_project?(project)).to eq(false)
  #     end
  #
  #     it "redirect_to project_path" do
  #       project = create(:project, user: member)
  #       post :quit, params: {id: project.id}
  #       expect(response).to redirect_to project_path(project)
  #     end
  #
  #   end
  #
  # end


end
