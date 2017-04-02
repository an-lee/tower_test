class Project < ApplicationRecord
  validates :title, presence: true
  belongs_to :user
  belongs_to :team
  has_many :todos
  has_many :accesses
  has_many :members, :through => :accesses, :source => :user
end
