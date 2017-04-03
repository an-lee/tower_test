class Event < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :project
  belongs_to :todo
  scope :recent, -> {order("created_at DESC")}

  def self.build(user, action, todo, project)
    @event = Event.new(:action => action)
    @event.user = user
    @event.project = project
    @event.team = project.team
    @event.todo = todo
    @event.save!
  end

  def self.build1(user, action, todo, project, message, category)
    @event = Event.new(:action => action,
                       :content => message.content)
    @event.user = user
    @event.project = project
    @event.team = project.team
    @event.todo = todo
    @event.category = category
    @event.save!
  end

end
