class Event < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :project
  belongs_to :todo, optional: true
  scope :recent, -> {order("id DESC")}

# 创建一般的任务 event
  def self.build_todo(user, action, todo, project, team)
    @event = Event.new(:action => action)
    @event.user = user
    @event.project = project
    @event.team = team
    @event.todo = todo
    @event.save!
  end

# 创建任务下的评论 event
  def self.build_todo_message(user, action, todo, content, category)
    @event = Event.new(:action => action,
                       :content => content)
    @event.user = user
    @event.todo = todo
    @event.project = todo.project
    @event.team = todo.team
    @event.category = category
    # byebug
    @event.save!
  end

  # 创建项目下的评论 event
  def self.build_proj_message(user, action, project, content, category)
    @event = Event.new(:action => action,
                       :content => content)
    @event.user = user
    @event.project = project
    # byebug
    @event.team = project.team
    @event.category = category
    @event.save!
  end

end
