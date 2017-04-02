class Team < ApplicationRecord
  validates :title, presence: true
  belongs_to :user
  has_many :accesses
  has_many :member, :through => :accesses, :source => user
end
