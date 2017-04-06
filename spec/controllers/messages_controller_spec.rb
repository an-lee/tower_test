require 'rails_helper'

RSpec.describe MessagesController, type: :controller do

  describe "GET new: " do
    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

    context "when login as member of project" do
      before {sign_in member}
      it "assigns @messages" do
        project = create(:project, :user => member)
        todo = create(:todo, :project => project)
        member.join_project!(project)
        get :new, params: { project_id: project.id, todo_id: todo.id }
        expect(assigns(:message)).to be_a_new(Message)
      end

      it "render new template" do
        project = create(:project, :user => member)
        todo = create(:todo, :project => project)
        member.join_project!(project)
        get :new, params: { project_id: project.id, todo_id: todo.id}
        expect(response).to render_template("new")
      end
    end

    context "when login not as member of project" do
      before {sign_in not_member}

      it "raise errors" do
        project = create(:project, :user => member)
        todo = create(:todo, :project => project)
        expect do
          get :new, params: { project_id: project.id, todo_id: todo.id }
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context "when not login" do
      it "redirect_to new_user_session_path" do
        project = create(:project, :user => member)
        todo = create(:todo, :project => project)
        get :new, params: { project_id: project.id, todo_id: todo.id}
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

# =======================

  describe "POST create: " do

    let(:member) {create(:user)}
    let(:not_member) {create(:user)}

      context "when todo dosen't have content" do
        before {sign_in member}

        it "doesn't create a record" do
          project = create(:project, :user => member)
          todo = create(:todo, :project => project)
          member.join_project!(project)
          expect do
            post :create, params: {:project_id => project.id, :todo_id => todo.id, message: {content: ""}}
          end.to change { Message.count }.by(0)
        end

        it "render new template" do
          project = create(:project, :user => member)
          todo = create(:todo, :project => project)
          member.join_project!(project)
          post :create, params: {:project_id => project.id, :todo_id => todo.id, message: {content: ""}}
          expect(response).to render_template("new")
        end

      end

      context "when todo has content" do
        before {sign_in member}

        it "create a new todo record" do
          project = create(:project, :user => member)
          todo = create(:todo, :project => project)
          member.join_project!(project)
          expect do
            post :create, params: {:project_id => project.id, :todo_id => todo.id, message: attributes_for(:message)}
          end.to change {Message.count}.by(1)
        end

        it "redirect_to project_todo_path" do
          project = create(:project, :user => member)
          todo = create(:todo, :project => project)
          member.join_project!(project)
          post :create, params:  {:project_id => project.id, :todo_id => todo.id, message: attributes_for(:message)}
          expect(response).to redirect_to project_todo_path(project, todo)
        end

        it "creates a message" do
          project = create(:project, :user => member)
          todo = create(:todo, :project => project)
          member.join_project!(project)
          message = build(:message)
          post :create, params:  {:project_id => project.id, :todo_id => todo.id, message: attributes_for(:message)}
          expect(Message.last.user).to eq(member)
        end

      end

    end


end
