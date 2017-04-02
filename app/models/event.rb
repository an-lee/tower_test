class Event < ApplicationRecord
  belongs_to :user
  belongs_to :team
  belongs_to :project
  belongs_to :todo
  scope :recent, -> {order("created_at DESC")}
end
