class Todo < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :events
end
