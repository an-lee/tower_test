require 'rails_helper'

RSpec.describe Event, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it { is_expected.to belong_to(:user)}
  it { is_expected.to belong_to(:todo)}
  it { is_expected.to belong_to(:project)}
  it { is_expected.to belong_to(:team)}

# ======================================
  describe '.build by todo trigger' do
    before do
      @user = User.create(:email => "test1@example.com", :password => "111111")
      @team = Team.create(:title => "Team_1", :user => @user)
      # @team.members <= @user
      @project = Project.create(:title => "Project_1", :user=> @user)
    end
# ---------------
    context 'when todo created' do

      it "should create an event" do
        @todo = Todo.create(:title => "Todo_1",
                           :user => @user,
                           :project => @project,
                           :team => @team)
        @todo.save!
        event = Event.last
        expect(event.action).to eq("创建了任务")
      end

    end
# ---------------
    context "when todo updated" do

      before do
        @todo = Todo.create(:title => "Todo_1",
                           :user => @user,
                           :project => @project,
                           :team => @team)
        @t = Date.today
      end

      it "should create an event when new assign" do
        @todo.update(:assign => "Mike")
        event = Event.last
        expect(event.action).to eq("给 Mike 指派了任务")
      end

      it "should create an event when re-assign" do
        @todo.update(:assign => "Mike")
        @todo.update(:assign => "Jack")
        event = Event.last
        expect(event.action).to eq("把 Mike 的任务指派给了 Jack")
      end

      it "should create an event when set due date" do
        @todo.update(:due => @t)
        event = Event.last
        expect(event.action).to eq("将任务完成时间从 没有截止日期 修改为 #{@t.to_s}")
      end

      it "should create an event when reset due date" do
        @todo.update(:due => @t)
        @todo.update(:due => @t.tomorrow)
        event = Event.last
        # byebug
        expect(event.action).to eq("将任务完成时间从 #{@t.to_s} 修改为 #{@t.tomorrow.to_s}")
      end

      it "should create an event when trash a todo" do
        @todo.update(:is_trash => true)
        event = Event.last
        # byebug
        expect(event.action).to eq("删除了任务")
      end

      it "should create an event when untrash a todo" do
        @todo.update(:is_trash => true)
        @todo.update(:is_trash => false)
        event = Event.last
        # byebug
        expect(event.action).to eq("恢复了任务")
      end

      it "should create an event when complete a todo" do
        @todo.update(:is_completed => true)
        event = Event.last
        # byebug
        expect(event.action).to eq("完成了任务")
      end

      it "should create an event when uncomplete a todo" do
        @todo.update(:is_completed => true)
        @todo.update(:is_completed => false)
        event = Event.last
        # byebug
        expect(event.action).to eq("重新打开了任务")
      end

    end
# ---------------
  end

# ======================================

  describe '.build by message trigger' do

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
