class Todo < ApplicationRecord
  after_create :event_build_when_created
  after_update :event_build_when_updated
  validates :title, presence: true
  belongs_to :project
  belongs_to :user
  belongs_to :team
  has_many :events
  has_many :messages

  def untrash!
    self.is_trash = false
    self.save!
  end

  def trash!
    self.is_trash = true
    self.save!
  end

  def uncomplete!
    self.is_completed = false
    self.save!
  end

  def complete!
    self.is_completed = true
    self.save!
  end

  protected

  def event_build_when_created
    Event.build_todo(self.user, "创建了任务", self, self.project, self.team)
  end

  def event_build_when_updated
    # 删除任务触发 event
    if self.is_trash_changed? && self.is_trash == true
      Event.build_todo(self.user, "删除了任务", self, self.project, self.team)
    # 恢复任务触发 event
    elsif self.is_trash_changed? && self.is_trash == false
      Event.build_todo(self.user, "恢复了任务", self, self.project, self.team)
    # 完成任务触发 event
    elsif self.is_completed_changed? && self.is_completed == true
      Event.build_todo(self.user, "完成了任务", self, self.project, self.team)
    # 重新打开任务触发 event
    elsif self.is_completed_changed? && self.is_completed == false
      Event.build_todo(self.user, "重新打开了任务", self, self.project, self.team)
    # 指派任务触发 event
    elsif self.assign_changed? && self.assign_was == nil
      Event.build_todo(self.user, "给 #{self.assign} 指派了任务", self, self.project, self.team)
    # 重新指派任务触发 event
    elsif self.assign_changed? && self.assign_was != nil
      Event.build_todo(self.user, "把 #{self.assign_was} 的任务指派给了 #{self.assign}", self, self.project, self.team)
    # 设定截止时间触发 event
    elsif self.due_changed? && self.due_was == nil
      Event.build_todo(self.user, "将任务完成时间从 没有截止日期 修改为 #{self.due}", self, self.project, self.team)
    # 重新设定截止时间触发 event
    elsif self.due_changed? && self.due_was != nil
      Event.build_todo(self.user, "将任务完成时间从 #{self.due_was} 修改为 #{self.due}", self, self.project, self.team)
    end
  end

end
