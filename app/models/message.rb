class Message < ApplicationRecord
  after_create :event_build_when_new_message
  validates :content, presence: true
  belongs_to :todo
  belongs_to :user
  belongs_to :project

  protected

  def event_build_when_new_message
    if self.todo != nil
      Event.build_todo_message(self.user, "回复了任务", self.todo, self.content, 1)
    else
      # Event.build_proj_message
    end

  end

end
