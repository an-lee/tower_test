class Project < ApplicationRecord
  validates :title, presence: true
  belongs_to :user
  has_many :accesses
  has_many :members, :through => :accesses, :source => :user
end
