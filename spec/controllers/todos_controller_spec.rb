require 'rails_helper'

RSpec.describe TodosController do


  describe "GET new: " do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when login as member of project" do
      before {sign_in member}
      it "assigns @todos" do
        team = create(:team, :user => member)
        project = create(:project, :user => member, :team => team)
        member.join_team!(team)
        member.join_project!(project)
        get :new, params: {user_id: member.id, project_id: project.id, team_id: team.id}
        expect(assigns(:todo)).to be_a_new(Todo)
      end

      it "render new template" do
        team = create(:team, :user => member)
        project = create(:project, :user => member, :team => team)
        member.join_team!(team)
        member.join_project!(project)
        get :new, params: { project_id: project.id, team_id: team.id}
        expect(response).to render_template("new")
      end
    end

    context "when login not as member of project" do
      before {sign_in not_member}

      it "raise errors" do
        team = create(:team, :user => member)
        project = create(:project, :user => member, :team => team)
        expect do
          get :new, params: { project_id: project.id, team_id: team.id}
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when not login" do
      it "redirect_to new_user_session_path" do
        team = create(:team, :user => member)
        project = create(:project, :user => member, :team => team)
        get :new, params: { project_id: project.id, team_id: team.id}
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

# =======================

  describe "POST create: " do

    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

      context "when todo dosen't have title" do
        before {sign_in member}

        it "doesn't create a record" do
          # team = create(:team, :user => member)
          project = create(:project, :user => member)
          # member.join_team!(team)
          member.join_project!(project)
          # byebug
          expect do
            post :create, params: {:project_id => project.id, todo: { description: "bar"}}
          end.to change { Todo.count }.by(0)
        end

        it "render new template" do
          project = create(:project, :user => member)
          member.join_project!(project)
          post :create, params: {:project_id => project.id, todo: { description: "bar"}}
          expect(response).to render_template("new")
        end

      end

      context "when todo has title" do
        before {sign_in member}

        it "create a new todo record" do
          project = create(:project, :user => member)
          member.join_project!(project)
          expect do
            post :create, params: {:project_id => project.id, todo: attributes_for(:todo)}
          end.to change {Todo.count}.by(1)
        end

        it "redirect_to project_path(project)" do
          project = create(:project, :user => member)
          member.join_project!(project)
          post :create, params:  {:project_id => project.id, todo: attributes_for(:todo)}
          expect(response).to redirect_to project_path(project)
        end

        it "creates a todo" do
          project = create(:project, :user => member)
          member.join_project!(project)
          todo = build(:todo)
          post :create, params:  {:project_id => project.id, todo: attributes_for(:todo)}
          expect(Todo.last.user).to eq(member)
        end

      end

    end

# =======================

  describe "PUT edit: " do

    let(:creator) {create(:user)}
    let(:admin) {create(:user)}
    let(:not_creator) {create(:user)}

    context "signed in as creator" do
      before {sign_in creator}

      it "assigns todo" do
        todo = create(:todo, user: creator)
        creator.join_project!(todo.project)
        get :edit, params: {:project_id => todo.project_id, :id => todo.id}
        expect(assigns[:todo]).to eq(todo)
      end

      it "renders edit template" do
        todo = create(:todo, user:creator)
        creator.join_project!(todo.project)
        get :edit, params: {:project_id => todo.project_id, :id => todo.id}
        expect(response).to render_template("edit")
      end

    end

    context "signed in as admin" do
      before {sign_in admin}

      it "assigns todo" do
        project = create(:project, user: admin)
        admin.join_project!(project)
        todo = create(:todo, user: creator, project: project)
        get :edit, params: {:project_id => project.id, :id => todo.id}
        expect(assigns[:todo]).to eq(todo)
      end

      it "renders template" do
        project = create(:project, user: admin)
        admin.join_project!(project)
        todo = create(:todo, user: creator, project: project)
        get :edit, params: {:project_id => project.id, :id => todo.id}
        expect(response).to render_template("edit")
      end

    end

    context "signed in not as creator nor admin" do
      before {sign_in not_creator}
      it "show alert and redirect" do
        project = create(:project, user: creator)
        not_creator.join_project!(project)
        todo = create(:todo, user: creator, project: project)
        get :edit, params: {:project_id => project.id, :id => todo.id}
        expect(response).to redirect_to project_path(project)
        expect(flash[:alert]).to be_present
      end

    end

  end

# =======================

  describe "PUT update: " do

    let(:creator) {create(:user)}
    let(:admin) {create(:user)}
    let(:not_creator) {create(:user)}

    context "when sign in as creator" do
      before {sign_in creator}

      context "when todo has title" do
        it "assigns @todo" do
          todo = create(:todo, user: creator)
          creator.join_project!(todo.project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
          expect(assigns[:todo]).to eq(todo)
        end

        it "changes value" do
          todo = create(:todo, user: creator)
          creator.join_project!(todo.project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
          expect(assigns[:todo].title).to eq("new Title")
          expect(assigns[:todo].description).to eq("new Description")
        end

        it "redirect_to todo_path" do
          todo = create(:todo, user: creator)
          creator.join_project!(todo.project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
          expect(response).to redirect_to project_todo_path(todo.project, todo)
        end
      end

      context "when todo doesn't has title" do

        it "doesn't update a record" do
          todo = create(:todo, user:creator)
          creator.join_project!(todo.project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "", description:"new Description"}}
          expect(todo.description).not_to eq("new Description")
        end

        it "renders edit template" do
          todo = create(:todo, user:creator)
          creator.join_project!(todo.project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "", description:"new Description"}}
          expect(response).to render_template("edit")
        end

      end

    end
    context "when sign in as admin" do
      before {sign_in admin}

      context "when todo has title" do
        it "assigns @todo" do
          project = create(:project, user: admin)
          admin.join_project!(project)
          todo = create(:todo, user:creator, project: project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
          expect(assigns[:todo]).to eq(todo)
        end

        it "changes value" do
          project = create(:project, user: admin)
          admin.join_project!(project)
          todo = create(:todo, user:creator, project: project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
          expect(assigns[:todo].title).to eq("new Title")
          expect(assigns[:todo].description).to eq("new Description")
        end

        it "redirect_to todo_path" do
          project = create(:project, user: admin)
          admin.join_project!(project)
          todo = create(:todo, user:creator, project: project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
          expect(response).to redirect_to project_todo_path(todo.project, todo)
        end
      end

      context "when todo doesn't has title" do

        it "doesn't update a record" do
          project = create(:project, user: admin)
          admin.join_project!(project)
          todo = create(:todo, user:creator, project: project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "", description:"new Description"}}
          expect(todo.description).not_to eq("new Description")
        end

        it "renders edit template" do
          project = create(:project, user: admin)
          admin.join_project!(project)
          todo = create(:todo, user:creator, project: project)
          put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "", description:"new Description"}}
          expect(response).to render_template("edit")
        end

      end

    end
    context "when sign in not as creator nor admin" do
      before {sign_in not_creator}

      it "raise alert and redirect" do
        todo = create(:todo, user:creator)
        not_creator.join_project!(todo.project)
        put :update, params: {project_id: todo.project_id, id: todo.id, todo:{ title: "new Title", description:"new Description"}}
        expect(response).to redirect_to project_path(todo.project)
        expect(flash[:alert]).to be_present
      end

    end

  end

# =======================
  #
  # describe "DELETE destroy: " do
  #   let(:creator) {create(:user)}
  #   let(:admin) {create(:user)}
  #   let(:not_creator) {create(:user)}
  #
  #   context "when sign in as admin" do
  #     before { sign_in admin }
  #
  #     it "assigns @todo" do
  #       project = create(:project, user: admin)
  #       admin.join_project!(project)
  #       todo = create(:todo, user:creator, project: project)
  #       delete :destroy, params: {project_id: project.id, id: todo.id}
  #       expect(assigns[:todo]).to eq(todo)
  #     end
  #
  #     it "delete a record" do
  #       project = create(:project, user: admin)
  #       admin.join_project!(project)
  #       todo = create(:todo, user:creator, project: project)
  #       expect do
  #         delete :destroy, params: {project_id: project.id, id: todo.id}
  #       end.to change{Todo.count}.by(-1)
  #     end
  #
  #     it "redirect_to project path" do
  #       project = create(:project, user: admin)
  #       admin.join_project!(project)
  #       todo = create(:todo, user:creator, project: project)
  #       delete :destroy, params: {project_id: project.id, id: todo.id}
  #       expect(response).to redirect_to project_path(project)
  #     end
  #
  #   end
  #
  #   context "when sign in not as admin nor creator" do
  #     before { sign_in not_creator }
  #     it "raise an error" do
  #       project = create(:project, user: admin)
  #       not_creator.join_project!(project)
  #       todo = create(:todo, user:creator, project: project)
  #       expect do
  #         delete :destroy, params: {project_id: project.id, id: todo.id}
  #       end.to raise_error ActiveRecord::RecordNotFound
  #     end
  #
  #   end
  #
  # end

# =======================

  describe "PUT assign" do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when sign in as project member" do
      before {sign_in member}

      it "can assign todo to somebody and trigger an event" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        put :assign, params: {project_id: project.id, id: todo.id, todo: {assign: "Jack"} }
        # byebug
        expect(Todo.last.assign).to eq("Jack")
        expect(Event.last.action).to eq("给 Jack 指派了任务")
      end

      it "can re-assign somebody's todo to someone else and trigger an event" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        put :assign, params: {project_id: project.id, id: todo.id, todo: {assign: "Jack"} }
        put :assign, params: {project_id: project.id, id: todo.id, todo: {assign: "Mike"} }
        # byebug
        expect(Todo.last.assign).to eq("Mike")
        expect(Event.last.action).to eq("把 Jack 的任务指派给了 Mike")
      end

      it "redirect_to project_path" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        put :assign, params: {project_id: project.id, id: todo.id, todo: {assign: "Jack"} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in not as member" do
      before {sign_in not_member}

      it "raise errors" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        expect do
          put :assign, params: {project_id: project.id, id: todo.id, todo: {assign: "Jack"} }
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================

  describe "PUT due: " do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when sign in as member" do
      before {sign_in member}

      it "can set a due to todo" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        put :due, params: {project_id: project.id, id: todo.id, todo: {due: Date.today} }
        # byebug
        expect(Todo.last.due).to eq(Date.today)
        expect(Event.last.action).to eq("将任务完成时间从 没有截止日期 修改为 #{Date.today}")
      end

      it "can re-assign somebody's todo to someone else and trigger an event" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        put :due, params: {project_id: project.id, id: todo.id, todo: {due: Date.today} }
        put :due, params: {project_id: project.id, id: todo.id, todo: {due: Date.tomorrow} }
        # byebug
        expect(Todo.last.due).to eq(Date.tomorrow)
        expect(Event.last.action).to eq("将任务完成时间从 #{Date.today} 修改为 #{Date.tomorrow}")
      end

      it "redirect_to project_path" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        put :due, params: {project_id: project.id, id: todo.id, todo: {due: Date.today} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in not as member" do
      before {sign_in not_member}

      it "raise errors" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        expect do
          put :due, params: {project_id: project.id, id: todo.id, todo: {due: Date.today} }
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================

  describe "POST trash: " do
    let(:creator) {create(:user)}
    let(:admin) {create(:user)}
    let(:not_creator){create(:user)}

    context "when sign in as admin" do
      before {sign_in admin}

      it "set todo trashed, and trigger an event" do
        project = create(:project, user: admin)
        admin.join_project!(project)
        todo = create(:todo, project: project, user: creator)
        post :trash, params: {project_id: project.id, id: todo.id, todo: {is_trash: true} }
        expect(Todo.last.is_trash).to eq(true)
        expect(Event.last.action).to eq("删除了任务")
      end

      it "redirect_to project_path" do
        project = create(:project, user: admin)
        admin.join_project!(project)
        todo = create(:todo, project: project, user: creator)
        post :trash, params: {project_id: project.id, id: todo.id, todo: {is_trash: true} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in as creator" do
      before {sign_in creator}

      it "set todo trashed, and trigger an event" do
        project = create(:project, user: admin)
        creator.join_project!(project)
        todo = create(:todo, project: project, user: creator)
        post :trash, params: {project_id: project.id, id: todo.id, todo: {is_trash: true} }
        expect(Todo.last.is_trash).to eq(true)
        expect(Event.last.action).to eq("删除了任务")
      end

      it "redirect_to project_path" do
        project = create(:project, user: admin)
        creator.join_project!(project)
        todo = create(:todo, project: project, user: creator)
        post :trash, params: {project_id: project.id, id: todo.id, todo: {is_trash: true} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in not as creator nor admin" do
      before {sign_in not_creator}
      it "raise alert and redirect" do
        project = create(:project, user: creator)
        not_creator.join_project!(project)
        todo = create(:todo, project: project, user: creator)
        post :trash, params: {project_id: project.id, id: todo.id, todo: {is_trash: true} }
        expect(response).to redirect_to project_path(todo.project)
        expect(flash[:alert]).to be_present
      end

    end

  end

# =======================

  describe "POST untrash: " do
    let(:creator) {create(:user)}
    let(:admin) {create(:user)}
    let(:not_creator){create(:user)}

    context "when sign in as admin" do
      before {sign_in admin}

      it "set todo untrash, and trigger an event" do
        project = create(:project, user: admin)
        admin.join_project!(project)
        todo = create(:todo, project: project, user: creator, is_trash: true)
        post :untrash, params: {project_id: project.id, id: todo.id, todo: {is_trash: false} }
        expect(Todo.last.is_trash).to eq(false)
        expect(Event.last.action).to eq("恢复了任务")
      end

      it "redirect_to project_path" do
        project = create(:project, user: admin)
        admin.join_project!(project)
        todo = create(:todo, project: project, user: creator, is_trash: true)
        post :untrash, params: {project_id: project.id, id: todo.id, todo: {is_trash: false} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in as creator" do
      before {sign_in creator}

      it "set todo untrash, and trigger an event" do
        project = create(:project, user: admin)
        creator.join_project!(project)
        todo = create(:todo, project: project, user: creator, is_trash: true)
        post :untrash, params: {project_id: project.id, id: todo.id, todo: {is_trash: false} }
        expect(Todo.last.is_trash).to eq(false)
        expect(Event.last.action).to eq("恢复了任务")
      end

      it "redirect_to project_path" do
        project = create(:project, user: admin)
        creator.join_project!(project)
        todo = create(:todo, project: project, user: creator, is_trash: true)
        post :untrash, params: {project_id: project.id, id: todo.id, todo: {is_trash: false} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in not as creator nor admin" do
      before {sign_in not_creator}
      it "raise alert and redirect" do
        project = create(:project, user: creator)
        not_creator.join_project!(project)
        todo = create(:todo, project: project, user: creator, is_trash: true)
        post :untrash, params: {project_id: project.id, id: todo.id, todo: {is_trash: false} }
        expect(response).to redirect_to project_path(project)
        expect(flash[:alert]).to be_present
      end

    end

  end

# =======================

  describe "POST complete: " do
    let(:member) {create(:user)}
    let(:not_member){create(:user)}

    context "when sign in as member" do
      before {sign_in member}

      it "set todo completed, and trigger an event" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        post :complete, params: {project_id: project.id, id: todo.id, todo: {is_completed: true} }
        expect(Todo.last.is_completed).to eq(true)
        expect(Event.last.action).to eq("完成了任务")
      end

      it "redirect_to project_path" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member)
        post :complete, params: {project_id: project.id, id: todo.id, todo: {is_completed: true} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in not as member" do
      before {sign_in not_member}
      it "raise errors" do
        project = create(:project, user: member)
        todo = create(:todo, project: project, user: member)
        expect do
          post :trash, params: {project_id: project.id, id: todo.id, todo: {is_trash: true} }
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================

  describe "POST uncomplete: " do
    let(:member) {create(:user)}
    let(:not_member){create(:user)}

    context "when sign in as member" do
      before {sign_in member}

      it "set todo completed, and trigger an event" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member, is_completed: true)
        post :uncomplete, params: {project_id: project.id, id: todo.id, todo: {is_completed: false} }
        expect(Todo.last.is_completed).to eq(false)
        expect(Event.last.action).to eq("重新打开了任务")
      end

      it "redirect_to project_path" do
        project = create(:project, user: member)
        member.join_project!(project)
        todo = create(:todo, project: project, user: member, is_completed: true)
        post :uncomplete, params: {project_id: project.id, id: todo.id, todo: {is_completed: false} }
        expect(response).to redirect_to project_path(project)
      end

    end

    context "when sign in not as member" do
      before {sign_in not_member}
      it "raise errors" do
        project = create(:project, user: member)
        todo = create(:todo, project: project, user: member, is_completed: true)
        expect do
          post :uncomplete, params: {project_id: project.id, id: todo.id, todo: {is_completed: false} }
        end.to raise_error ActiveRecord::RecordNotFound
      end

    end

  end

# =======================


end
