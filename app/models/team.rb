class Team < ApplicationRecord
  validates :title, presence: true
  belongs_to :user
  has_many :projects
end
