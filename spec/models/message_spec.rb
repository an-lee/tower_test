require 'rails_helper'

RSpec.describe Message, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to validate_presence_of(:content)}
  it { is_expected.to belong_to(:user)}
  it { is_expected.to belong_to(:todo)}
  it { is_expected.to belong_to(:project)}


  describe 'trigger an event' do

    before do
      @user = User.create(:email => "test1@example.com", :password => "111111")
      @team = Team.create(:title => "Team_1", :user => @user)
      @project = Project.create(:title => "Project_1", :team => @team, :user=> @user)
      @todo = Todo.create(:title => "Todo_1", :user => @user, :team => @team, :project => @project)
    end

# ---------------
    context 'when todo_message created' do

      it 'should create an event' do
        @message = Message.create(:content => "任务很艰巨",
                                  :user => @user,
                                  :todo => @todo,
                                  :project => @project)
        @message.save!
        # byebug
        event = Event.last
        expect(event.action).to eq("回复了任务")
        expect(event.content).to eq(@message.content)
      end

    end

# ---------------
    context 'when project_message created' do

      it 'should create an event' do
        @message = Message.create(:content => "这个项目不错",
                                  :user => @user,
                                  :project => @project)
        @message.save!
        # byebug
        event = Event.last
        expect(event.action).to eq("创建了讨论")
        expect(event.content).to eq(@message.content)
      end

    end
  end

end
