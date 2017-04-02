class Todo < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :events

  def untrash!
    self.is_trash = false
    self.save
  end

  def trash!
    self.is_trash = true
    self.save
  end

  def uncomplete!
    self.is_completed = false
    self.save
  end

  def complete!
    self.is_completed = true
    self.save
  end

end
