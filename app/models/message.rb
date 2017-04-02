class Message < ApplicationRecord
  validates :content, presence: true
  belongs_to :todo
  belongs_to :user
end
